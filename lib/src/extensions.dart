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

  double get adaptivePadding {
    if (isMobile) return 12;
    if (isTablet) return 16;
    return 24;
  }

  double get adaptiveFontScale {
    if (densityType == DensityType.ultra) return 1.1;
    if (densityType == DensityType.low) return 0.9;
    return 1.0;
  }
}
