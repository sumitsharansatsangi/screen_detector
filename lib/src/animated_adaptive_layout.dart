import 'package:flutter/widgets.dart';

import 'adaptive_breakpoints.dart';
import 'enums.dart';
import 'screen_provider.dart';

/// An animated version of [AdaptiveLayout] that provides smooth transitions
/// between different screen size layouts.
///
/// This widget automatically animates changes when switching between breakpoints,
/// providing a smoother user experience during window resizing or device rotation.
class AnimatedAdaptiveLayout extends StatefulWidget {
  /// Widget to display on compact screens.
  final Widget? compact;

  /// Widget to display on medium screens.
  final Widget? medium;

  /// Widget to display on expanded screens.
  final Widget? expanded;

  /// Widget to display on large screens.
  final Widget? large;

  /// Custom breakpoints to use instead of Material Design defaults.
  final AdaptiveBreakpoints? breakpoints;

  /// Duration of the animation when switching layouts.
  final Duration duration;

  /// Animation curve to use for transitions.
  final Curve curve;

  /// Creates an [AnimatedAdaptiveLayout].
  ///
  /// The [duration] defaults to 300ms and [curve] defaults to [Curves.easeInOut].
  const AnimatedAdaptiveLayout({
    super.key,
    this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.breakpoints,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedAdaptiveLayout> createState() => _AnimatedAdaptiveLayoutState();
}

class _AnimatedAdaptiveLayoutState extends State<AnimatedAdaptiveLayout> {
  ScreenType? _previousScreenType;
  ScreenType? _currentScreenType;
  Widget? _previousChild;
  Widget? _currentChild;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLayout();
  }

  @override
  void didUpdateWidget(AnimatedAdaptiveLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLayout();
  }

  void _updateLayout() {
    final screen = context.screen;
    final effectiveBreakpoints =
        widget.breakpoints ?? AdaptiveBreakpoints.material;
    final newScreenType = effectiveBreakpoints.getScreenType(screen.width);

    if (newScreenType != _currentScreenType) {
      setState(() {
        _previousScreenType = _currentScreenType;
        _previousChild = _currentChild;
        _currentScreenType = newScreenType;
        _currentChild = _getChildForScreenType(newScreenType);
      });
    }
  }

  Widget? _getChildForScreenType(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.compact:
        return widget.compact;
      case ScreenType.medium:
        return widget.medium ?? widget.compact;
      case ScreenType.expanded:
        return widget.expanded ?? widget.medium ?? widget.compact;
      case ScreenType.large:
        return widget.large ??
            widget.expanded ??
            widget.medium ??
            widget.compact;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_previousChild == null || _currentChild == null) {
      // First build or no animation needed
      return _currentChild ?? const SizedBox();
    }

    if (_previousScreenType == _currentScreenType) {
      // No change in screen type
      return _currentChild!;
    }

    // Animate between layouts
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: widget.curve,
      switchOutCurve: widget.curve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey(_currentScreenType),
        child: _currentChild!,
      ),
    );
  }
}
