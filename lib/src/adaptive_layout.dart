import 'package:flutter/widgets.dart';

import 'enums.dart';
import 'screen_provider.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget? compact;
  final Widget? medium;
  final Widget? expanded;
  final Widget? large;

  const AdaptiveLayout({
    super.key,
    this.compact,
    this.medium,
    this.expanded,
    this.large,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    switch (screen.screenType) {
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
