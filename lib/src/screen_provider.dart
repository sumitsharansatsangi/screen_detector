
import 'package:flutter/widgets.dart';

import 'detector.dart';
import 'screen_info.dart';

class ScreenProvider extends StatefulWidget {
  final Widget child;

  const ScreenProvider({super.key, required this.child});

  @override
  State<ScreenProvider> createState() => _ScreenProviderState();
}

class _ScreenProviderState extends State<ScreenProvider> {
  ScreenInfo? _screen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(covariant ScreenProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  void _update() {
    final newScreen = ScreenDetector.of(context);

    if (_screen != newScreen) {
      setState(() => _screen = newScreen);
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


extension ScreenContext on BuildContext {
  ScreenInfo get screen => _ScreenInherited.of(this);
}
