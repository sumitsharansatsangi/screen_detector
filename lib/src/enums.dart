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
  unknown,
}

enum DeviceCategory {
  mobile,
  tablet,
  desktop,
  tv,
  foldable,
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
