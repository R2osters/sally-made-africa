/// Design tokens — spacing and corner radii. No magic numbers in screens.
/// Scale base 4: 4 / 8 / 12 / 16 / 22 / 26 / 34.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 22;
  static const double xxl = 26;
  static const double xxxl = 34;

  /// Content gutters (22–26 px per spec).
  static const double gutter = 24;

  /// Bottom clearance on tabbed screens so content clears the floating nav.
  static const double navClearance = 128;
}

abstract final class AppRadius {
  static const double input = 16;
  static const double button = 18;
  static const double card = 22;
  static const double sheet = 34;
  static const double pill = 999;

  // Legacy aliases still used by pre-redesign widgets.
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 22;
}
