/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; Ynotes Design System ✨
library;

/// Ynotes spacing and radius constants.
///
/// Use these instead of magic numbers throughout the Ynotes UI layer.
/// Values are based on a 4 pt base unit.
abstract final class YnotesSpacing {
  // ── Base unit: 4 pt ───────────────────────────────────────────────────────

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xl2 = 24;
  static const double xl3 = 32;
  static const double xl4 = 40;
  static const double xl5 = 48;
  static const double xl6 = 64;

  // ── Layout-specific ───────────────────────────────────────────────────────

  /// Width of the sidebar / rail on iPad.
  static const double sidebarWidth = 260;

  /// Collapsed sidebar / icon-only rail width.
  static const double sidebarCollapsedWidth = 68;

  /// Height of the bottom tab bar on iPhone.
  static const double bottomBarHeight = 56;

  /// Height of the floating toolbar strip.
  static const double toolbarHeight = 52;

  /// Width of each tool button in the toolbar.
  static const double toolButtonWidth = 48;

  /// Padding inside toolbar strip.
  static const double toolbarPadding = 8;
}

/// Ynotes border-radius constants.
abstract final class YnotesRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;

  /// Radius used for toolbar strip container.
  static const double toolbar = md;

  /// Radius used for cards and sheets.
  static const double card = lg;

  /// Radius used for small chip / badge elements.
  static const double chip = sm;
}
