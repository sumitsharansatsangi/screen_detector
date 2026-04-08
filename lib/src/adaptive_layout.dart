import 'package:flutter/widgets.dart';

import 'adaptive_breakpoints.dart';
import 'enums.dart';
import 'screen_provider.dart';

/// A widget that displays different layouts based on screen size breakpoints.
///
/// This widget automatically selects the appropriate child widget based on the
/// current screen size. By default, it uses Material Design 3 breakpoints:
/// - [compact]: Screen width < 600dp (phones in portrait)
/// - [medium]: Screen width 600-839dp (tablets, phones in landscape)
/// - [expanded]: Screen width 840-1199dp (desktop windows)
/// - [large]: Screen width ≥ 1200dp (large screens, TVs)
///
/// You can customize these breakpoints using the [breakpoints] parameter.
///
/// If a specific breakpoint widget is not provided, it falls back to smaller
/// breakpoints in the order: large → expanded → medium → compact.
///
/// Example with default breakpoints:
/// ```dart
/// AdaptiveLayout(
///   compact: MobileLayout(),
///   medium: TabletLayout(),
///   expanded: DesktopLayout(),
///   large: TVLayout(),
/// )
/// ```
///
/// Example with custom breakpoints:
/// ```dart
/// AdaptiveLayout(
///   breakpoints: AdaptiveBreakpoints.dense,
///   compact: MobileLayout(),
///   medium: TabletLayout(),
///   expanded: DesktopLayout(),
/// )
/// ```
class AdaptiveLayout extends StatelessWidget {
  final Widget? compact;
  final Widget? medium;
  final Widget? expanded;
  final Widget? large;

  /// Custom breakpoints to use instead of Material Design defaults.
  final AdaptiveBreakpoints? breakpoints;

  const AdaptiveLayout({
    super.key,
    this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    final effectiveBreakpoints = breakpoints ?? AdaptiveBreakpoints.material;

    // Use custom breakpoints to determine screen type
    final effectiveScreenType =
        effectiveBreakpoints.getScreenType(screen.width);

    switch (effectiveScreenType) {
      case ScreenType.compact:
        return compact ?? const SizedBox();

      case ScreenType.medium:
        return medium ?? compact ?? const SizedBox();

      case ScreenType.expanded:
        return expanded ?? medium ?? compact ?? const SizedBox();

      case ScreenType.large:
        return large ?? expanded ?? medium ?? compact ?? const SizedBox();
    }
  }
}
