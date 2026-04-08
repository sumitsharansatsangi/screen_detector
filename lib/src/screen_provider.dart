import 'package:flutter/widgets.dart';

import 'detector.dart';
import 'screen_info.dart';

/// Provides screen detection information to descendant widgets.
///
/// Wrap your app's root widget with [ScreenProvider] to enable screen
/// detection throughout the widget tree. Access screen information using
/// `context.screen` extension.
///
/// Example:
/// ```dart
/// void main() {
///   runApp(const ScreenProvider(child: MyApp()));
/// }
/// ```
class ScreenProvider extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates a [ScreenProvider].
  ///
  /// The [child] parameter must not be null.
  const ScreenProvider({super.key, required this.child});

  @override
  State<ScreenProvider> createState() => _ScreenProviderState();
}

class _ScreenProviderState extends State<ScreenProvider> {
  ScreenInfo? _screen;
  MediaQueryData? _lastMediaQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ScreenProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateIfNeeded();
  }

  void _updateIfNeeded() {
    final currentMediaQuery = MediaQuery.of(context);

    // Only update if MediaQuery data has actually changed
    if (_lastMediaQuery != currentMediaQuery) {
      _lastMediaQuery = currentMediaQuery;
      final newScreen = ScreenDetector.of(context);

      if (_screen != newScreen) {
        setState(() => _screen = newScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screen == null) return const SizedBox();

    return _ScreenInherited(
      screen: _screen!,
      child: widget.child,
    );
  }
}

class _ScreenInherited extends InheritedWidget {
  final ScreenInfo screen;

  const _ScreenInherited({
    required this.screen,
    required super.child,
  });

  static ScreenInfo of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_ScreenInherited>();
    assert(widget != null, 'ScreenProvider not found');
    return widget!.screen;
  }

  @override
  bool updateShouldNotify(covariant _ScreenInherited oldWidget) {
    return oldWidget.screen != screen;
  }
}

/// Extension on [BuildContext] to provide easy access to screen information.
///
/// Requires a [ScreenProvider] ancestor to function properly.
extension ScreenContext on BuildContext {
  /// Gets the current screen information.
  ///
  /// Throws an assertion error if no [ScreenProvider] is found in the widget tree.
  ///
  /// Example:
  /// ```dart
  /// final screen = context.screen;
  /// if (screen.isMobile) {
  ///   // Mobile-specific logic
  /// }
  /// ```
  ScreenInfo get screen => _ScreenInherited.of(this);
}
