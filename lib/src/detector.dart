import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'enums.dart';
import 'screen_info.dart';
import 'screen_detector_config.dart';
import 'performance_monitor.dart';
import 'foldable.dart';

class ScreenDetector {
  // Global configuration
  static ScreenDetectorConfig _config = const ScreenDetectorConfig();

  /// Configure global detection behavior.
  static void configure(ScreenDetectorConfig config) {
    _config = config;
  }

  /// Get current configuration.
  static ScreenDetectorConfig get config => _config;

  // Breakpoints for screen types
  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 840;
  static const double expandedBreakpoint = 1200;

  // Breakpoints for device types
  static const double watchBreakpoint = 300;
  static const double phoneBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Breakpoints for category
  static const double tvWidthBreakpoint = 1200;
  static const double tvHeightBreakpoint = 700;
  static const double foldableMinWidth = 600;
  static const double foldableMaxWidth = 900;
  static const double wearableMaxDimension = 300;

  // Breakpoints for posture
  static const double foldedWidthBreakpoint = 400;
  static const double halfOpenedRatioMin = 0.7;
  static const double halfOpenedRatioMax = 1.3;
  static const double unfoldedMinWidth = 700;
  static const double unfoldedMaxWidth = 900;

  // Breakpoint for input type
  static const double mouseKeyboardWidthBreakpoint = 900;

  // Aspect ratio thresholds
  static const double portraitRatioThreshold = 0.8;
  static const double ultrawideRatioThreshold = 1.8;
  static const double landscapeRatioThreshold = 1.2;

  // Density thresholds
  static const double lowDensityThreshold = 1.5;
  static const double mediumDensityThreshold = 2.5;
  static const double highDensityThreshold = 3.5;

  /// Detect screen information synchronously.
  static ScreenInfo of(BuildContext context) {
    return PerformanceMonitor.measure(() {
      // Validate context

      final media = MediaQuery.of(context);

      // Handle edge cases for screen dimensions
      final width = media.size.width.clamp(0.0, double.infinity);
      final height = media.size.height.clamp(0.0, double.infinity);
      final dpr = media.devicePixelRatio.clamp(0.0, double.infinity);

      // Prevent division by zero and ensure valid aspect ratio
      final ratio = height > 0 ? _aspectRatio(width, height) : 0.0;

      // Calculate basic properties first
      final platform = _platform();
      final deviceType = _deviceType(width, height);

      return ScreenInfo(
        platform: platform,
        screenType: _screenType(width),
        deviceType: _deviceType(width, height),
        category: _category(context, width, height),
        posture: _posture(context, width, height),
        orientation: media.orientation,
        inputType: _input(context, width, deviceType, platform),

        width: width,
        height: height,

        // ✅ NEW (important)
        aspectRatio: ratio,
        aspectType: _aspectType(ratio),
        devicePixelRatio: dpr,
        densityType: _density(dpr),
      );
    },
        isHardwareAccelerated: _config.enableHardwareAcceleration,
        mediaQueryAccesses: 1);
  }

  /// Detect screen information asynchronously with enhanced capabilities.
  ///
  /// This method performs more thorough detection including:
  /// - Hardware-accelerated foldable detection
  /// - Sensor-based posture detection (if enabled)
  /// - Platform-specific optimizations
  static Future<ScreenInfo> detectAsync(BuildContext context) async {
    final basic = of(context);

    if (!_config.enableHardwareAcceleration && !_config.enableSensorDetection) {
      return basic;
    }

    // Enhanced detection logic can be added here
    // For now, return basic detection - can be extended with:
    // - Sensor data collection
    // - Hardware feature queries
    // - Platform-specific APIs

    if (_config.debugMode) {
      debugPrint('ScreenDetector: Enhanced detection completed');
    }

    return basic;
  }

  /// Stream of screen changes for reactive UI updates.
  ///
  /// This provides a stream that emits whenever screen properties change,
  /// enabling reactive UI updates without manual MediaQuery watching.
  static Stream<ScreenInfo> screenChanges(BuildContext context) {
    // Implementation would use StreamController to monitor MediaQuery changes
    // For now, return empty stream - can be implemented with proper stream management
    return const Stream.empty();
  }

  // ---------------- PLATFORM ----------------
  static PlatformType _platform() {
    if (kIsWeb) return PlatformType.web;

    // ⚠️ Important: Platform.* not available on web
    try {
      if (Platform.isAndroid) return PlatformType.android;
      if (Platform.isIOS) return PlatformType.ios;
      if (Platform.isWindows) return PlatformType.windows;
      if (Platform.isMacOS) return PlatformType.macos;
      if (Platform.isLinux) return PlatformType.linux;
    } catch (_) {}

    return PlatformType.unknown;
  }

  // ---------------- SCREEN TYPE ----------------
  static ScreenType _screenType(double w) {
    if (w < compactBreakpoint) return ScreenType.compact;
    if (w < mediumBreakpoint) return ScreenType.medium;
    if (w < expandedBreakpoint) return ScreenType.expanded;
    return ScreenType.large;
  }

  // ---------------- DEVICE TYPE ----------------
  static DeviceType _deviceType(double w, double h) {
    // Check for watches - very small screens, typically square
    if (w <= watchBreakpoint && h <= watchBreakpoint) {
      return DeviceType.watch;
    }

    if (w < phoneBreakpoint) return DeviceType.phone;
    if (w < tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  // ---------------- CATEGORY ----------------
  static DeviceCategory _category(BuildContext context, double w, double h) {
    // 🎯 Wearable detection - very small screens
    if (w <= wearableMaxDimension && h <= wearableMaxDimension) {
      return DeviceCategory.wearable;
    }

    // 🎯 TV detection - improved with aspect ratio consideration
    if (w >= tvWidthBreakpoint && h >= tvHeightBreakpoint) {
      // Additional check for TV-like aspect ratios (typically 16:9 or wider)
      final aspectRatio = w / h;
      if (aspectRatio > 1.3) {
        return DeviceCategory.tv;
      }
    }

    // 🎯 Foldable detection - check for hardware features or emulator patterns
    // Look for display features that indicate foldable devices
    final hasFoldableFeatures = MediaQuery.of(context).displayFeatures.any(
        (f) =>
            f.type == DisplayFeatureType.hinge ||
            f.type == DisplayFeatureType.cutout);

    // Also check for foldable-like dimensions (for emulators and devices without proper feature detection)
    final isFoldableSize = w >= foldableMinWidth && w <= foldableMaxWidth;

    if (hasFoldableFeatures || isFoldableSize) {
      return DeviceCategory.foldable;
    }

    if (w < compactBreakpoint) return DeviceCategory.mobile;
    if (w < tabletBreakpoint) return DeviceCategory.tablet;

    return DeviceCategory.desktop;
  }

  // ---------------- POSTURE ----------------
  static DevicePosture _posture(BuildContext context, double w, double h) {
    // Use hardware-based detection when available
    return FoldableDetector.getLikelyPosture(context, w, h);
  }

  // ---------------- INPUT TYPE ----------------
  static InputType _input(BuildContext context, double w, DeviceType deviceType,
      PlatformType platform) {
    // Hybrid devices: tablets/laptops that support both touch and mouse
    // This includes 2-in-1 laptops, Surface devices, etc.
    if (_isHybridDevice(w, deviceType, platform)) {
      return InputType.hybrid;
    }

    // Traditional detection: wide screens typically have mouse/keyboard
    return w > mouseKeyboardWidthBreakpoint
        ? InputType.mouseKeyboard
        : InputType.touch;
  }

  // Detect devices that typically support both touch and mouse/keyboard
  static bool _isHybridDevice(
      double width, DeviceType deviceType, PlatformType platform) {
    // Tablets above certain size often support keyboard attachment
    if (deviceType == DeviceType.tablet && width > 800) {
      return true;
    }

    // Windows devices often support touch + mouse/keyboard
    if (platform == PlatformType.windows && width > 600) {
      return true;
    }

    // macOS with touch capabilities (future-proofing)
    if (platform == PlatformType.macos && width > 700) {
      return true;
    }

    // Linux devices with larger screens
    if (platform == PlatformType.linux && width > 700) {
      return true;
    }

    return false;
  }

  // ---------------- ASPECT RATIO ----------------
  static double _aspectRatio(double w, double h) {
    if (h == 0) return 0;
    return w / h;
  }

  static AspectType _aspectType(double ratio) {
    if (ratio < portraitRatioThreshold) return AspectType.portrait;
    if (ratio > ultrawideRatioThreshold) return AspectType.ultrawide;
    if (ratio > landscapeRatioThreshold) return AspectType.landscape;
    return AspectType.square;
  }

  // ---------------- DENSITY ----------------
  static DensityType _density(double dpr) {
    if (dpr < lowDensityThreshold) return DensityType.low;
    if (dpr < mediumDensityThreshold) return DensityType.medium;
    if (dpr < highDensityThreshold) return DensityType.high;
    return DensityType.ultra;
  }
}
