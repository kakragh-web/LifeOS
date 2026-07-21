/// Spacing scale for consistent padding and margins throughout the app.
/// Based on 4pt grid system.
class AppSpacing {
  AppSpacing._();

  // ─── Base Units ────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // ─── Semantic Spacing ──────────────────────────────────────────────
  static const double screenPadding = lg;
  static const double cardPadding = lg;
  static const double cardSpacing = lg;
  static const double listItemSpacing = md;
  static const double sectionSpacing = xl;
  static const double screenVerticalSpacing = xxl;

  // ─── Component Spacing ─────────────────────────────────────────────
  static const double buttonHeight = 56.0;
  static const double buttonPadding = lg;
  static const double fabSize = 56.0;
  static const double fabMargin = lg;
  static const double appBarHeight = 64.0;
  static const double bottomNavHeight = 80.0;

  // ─── Icon Sizes ────────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // ─── Divider ───────────────────────────────────────────────────────
  static const double dividerThickness = 1.0;
  static const double dividerIndent = xxl;

  // ─── Elevation Overlay ─────────────────────────────────────────────
  static const double elevationOverlay = 3.0;
}
