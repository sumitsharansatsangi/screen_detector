enum PlatformType {
  android,
  ios,
  windows,
  macos,
  linux,
  web,
  unknown,
}

enum ScreenType {
  compact,
  medium,
  expanded,
  large,
}

enum DeviceType {
  phone,
  tablet,
  desktop,
  watch,
  unknown,
}

enum DeviceCategory {
  mobile,
  tablet,
  desktop,
  tv,
  foldable,
  wearable,
}

enum DevicePosture {
  normal,
  folded,
  halfOpened,
  unfolded,
}

enum InputType {
  touch,
  mouseKeyboard,
  hybrid, // Supports both touch and mouse/keyboard (e.g., 2-in-1 laptops)
}

enum AspectType {
  portrait,
  landscape,
  square,
  ultrawide,
}

enum DensityType {
  low, // < 1.5
  medium, // 1.5 - 2.5
  high, // 2.5 - 3.5
  ultra, // > 3.5
}
