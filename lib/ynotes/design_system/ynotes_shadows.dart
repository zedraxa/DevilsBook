/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; Ynotes Design System ✨
library;

import 'package:flutter/material.dart';

/// Ynotes elevation shadow presets.
///
/// Used for floating toolbar, sheets, and cards.
abstract final class YnotesShadows {
  // ── Light-mode shadows ────────────────────────────────────────────────────

  /// Subtle card shadow.
  static const List<BoxShadow> cardLight = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Floating toolbar shadow (more prominent).
  static const List<BoxShadow> toolbarLight = [
    BoxShadow(
      color: Color(0x1E000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// Bottom sheet / popover shadow.
  static const List<BoxShadow> sheetLight = [
    BoxShadow(
      color: Color(0x28000000),
      blurRadius: 24,
      offset: Offset(0, -4),
    ),
  ];

  // ── Dark-mode shadows ─────────────────────────────────────────────────────

  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x28000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> toolbarDark = [
    BoxShadow(
      color: Color(0x3C000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> sheetDark = [
    BoxShadow(
      color: Color(0x3C000000),
      blurRadius: 24,
      offset: Offset(0, -4),
    ),
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────

  static List<BoxShadow> toolbar(Brightness brightness) =>
      brightness == Brightness.light ? toolbarLight : toolbarDark;

  static List<BoxShadow> card(Brightness brightness) =>
      brightness == Brightness.light ? cardLight : cardDark;

  static List<BoxShadow> sheet(Brightness brightness) =>
      brightness == Brightness.light ? sheetLight : sheetDark;
}
