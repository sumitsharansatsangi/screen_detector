import 'screen_info.dart';
import 'enums.dart';

extension ScreenInfoX on ScreenInfo {
  bool get useSidebar => isWide;

  bool get useBottomNav => screenType == ScreenType.compact;

  int get gridColumns {
    switch (screenType) {
      case ScreenType.compact:
        return 1;
      case ScreenType.medium:
        return 2;
      case ScreenType.expanded:
        return 3;
      case ScreenType.large:
        return 4;
    }
  }
}

extension AdvancedUI on ScreenInfo {
  bool get isUltrawide => aspectType == AspectType.ultrawide;

  bool get isLandscape => aspectType == AspectType.landscape;

  bool get isPortrait => aspectType == AspectType.portrait;

  bool get isHighDensity =>
      densityType == DensityType.high || densityType == DensityType.ultra;

  /// Whether this device has a very small screen typical of watches
  bool get isTinyScreen => isWatch;

  /// Whether this device is suitable for minimal UI (watches, small phones)
  bool get isMinimalUI => isWatch || (isMobile && width < 400);

  double get adaptivePadding {
    if (isWatch) return 4;
    if (isMobile) return 12;
    if (isTablet) return 16;
    return 24;
  }

  double get adaptiveFontScale {
    if (densityType == DensityType.ultra) return 1.1;
    if (densityType == DensityType.low) return 0.9;
    return 1.0;
  }

  /// Adaptive icon size based on device type
  double get adaptiveIconSize {
    if (isWatch) return 16;
    if (isMobile) return 24;
    if (isTablet) return 28;
    return 32;
  }

  /// Adaptive button height for touch targets
  double get adaptiveButtonHeight {
    if (isWatch) return 32; // Minimum touch target for watches
    if (isMobile) return 48;
    return 56;
  }

  /// Whether this device supports multiple input methods
  bool get supportsTouch =>
      inputType == InputType.touch || inputType == InputType.hybrid;

  /// Whether this device supports mouse/keyboard input
  bool get supportsMouseKeyboard =>
      inputType == InputType.mouseKeyboard || inputType == InputType.hybrid;
}
