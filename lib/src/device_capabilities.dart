import 'enums.dart';
import 'screen_info.dart';

/// Represents specific device capabilities and hardware features.
class DeviceCapabilities {
  /// Whether the device has a foldable screen.
  final bool hasFoldableScreen;

  /// Whether the device supports multiple input methods.
  final bool hasHybridInput;

  /// Whether the device has sensors for posture detection.
  final bool hasPostureSensors;

  /// Whether the device supports high refresh rate displays.
  final bool hasHighRefreshRate;

  /// Whether the device has HDR display capabilities.
  final bool hasHDRDisplay;

  /// Whether the device supports stylus input.
  final bool hasStylusSupport;

  /// Whether the device has biometric authentication.
  final bool hasBiometricAuth;

  const DeviceCapabilities({
    this.hasFoldableScreen = false,
    this.hasHybridInput = false,
    this.hasPostureSensors = false,
    this.hasHighRefreshRate = false,
    this.hasHDRDisplay = false,
    this.hasStylusSupport = false,
    this.hasBiometricAuth = false,
  });

  /// Detect device capabilities based on platform and screen info.
  static DeviceCapabilities detect(PlatformType platform, ScreenInfo screen) {
    return DeviceCapabilities(
      hasFoldableScreen: screen.isFoldable,
      hasHybridInput: screen.isHybridInput,
      hasPostureSensors: _detectPostureSensors(platform, screen),
      hasHighRefreshRate: _detectHighRefreshRate(platform, screen),
      hasHDRDisplay: _detectHDRDisplay(platform, screen),
      hasStylusSupport: _detectStylusSupport(platform, screen),
      hasBiometricAuth: _detectBiometricAuth(platform),
    );
  }

  static bool _detectPostureSensors(PlatformType platform, ScreenInfo screen) {
    // Android foldables often have posture sensors
    if (platform == PlatformType.android && screen.isFoldable) {
      return true;
    }
    return false;
  }

  static bool _detectHighRefreshRate(PlatformType platform, ScreenInfo screen) {
    // High-end Android and iOS devices often support 90Hz+
    if (platform == PlatformType.android || platform == PlatformType.ios) {
      return screen.devicePixelRatio > 2.5 || screen.width > 1000;
    }
    return false;
  }

  static bool _detectHDRDisplay(PlatformType platform, ScreenInfo screen) {
    // Premium devices often support HDR
    return (platform == PlatformType.android || platform == PlatformType.ios) &&
        screen.devicePixelRatio > 3.0;
  }

  static bool _detectStylusSupport(PlatformType platform, ScreenInfo screen) {
    // Certain Android tablets and iPads support stylus
    if (platform == PlatformType.ios && screen.isTablet) {
      return true; // iPad supports Apple Pencil
    }
    if (platform == PlatformType.android && screen.width > 800) {
      return true; // Many Android tablets support stylus
    }
    return false;
  }

  static bool _detectBiometricAuth(PlatformType platform) {
    // Most modern mobile devices have biometric auth
    return platform == PlatformType.android || platform == PlatformType.ios;
  }
}
