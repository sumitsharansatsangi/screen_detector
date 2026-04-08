import 'enums.dart';

/// Configurable breakpoints for adaptive layouts.
///
/// Allows customizing the screen size thresholds used by AdaptiveLayout
/// instead of using the default Material Design breakpoints.
class AdaptiveBreakpoints {
  /// The maximum width for compact layout.
  final double compact;

  /// The maximum width for medium layout.
  final double medium;

  /// The maximum width for expanded layout.
  final double expanded;

  /// The minimum width for large layout.
  final double large;

  const AdaptiveBreakpoints({
    this.compact = 600,
    this.medium = 840,
    this.expanded = 1200,
    this.large = 1200,
  }) : assert(compact > 0 && compact < medium && medium < expanded,
            'Breakpoints must be in ascending order: 0 < compact < medium < expanded');

  /// Material Design 3 breakpoints (default).
  static const material = AdaptiveBreakpoints(
    compact: 600,
    medium: 840,
    expanded: 1200,
    large: 1200,
  );

  /// Smaller breakpoints for denser layouts.
  static const dense = AdaptiveBreakpoints(
    compact: 480,
    medium: 720,
    expanded: 1024,
    large: 1024,
  );

  /// Larger breakpoints for spacious layouts.
  static const spacious = AdaptiveBreakpoints(
    compact: 720,
    medium: 960,
    expanded: 1440,
    large: 1440,
  );

  /// Custom breakpoints for tablets.
  static const tablet = AdaptiveBreakpoints(
    compact: 600,
    medium: 840,
    expanded: 1200,
    large: 1600,
  );

  /// Determines the screen type for a given width.
  ScreenType getScreenType(double width) {
    if (width < compact) return ScreenType.compact;
    if (width < medium) return ScreenType.medium;
    if (width < expanded) return ScreenType.expanded;
    return ScreenType.large;
  }
}
