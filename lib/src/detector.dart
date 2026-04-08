import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'enums.dart';
import 'screen_info.dart';

class ScreenDetector {
  static ScreenInfo of(BuildContext context) {
    final media = MediaQuery.of(context);

    final width = media.size.width;
    final height = media.size.height;
    final dpr = media.devicePixelRatio;

    final ratio = _aspectRatio(width, height);

    return ScreenInfo(
      platform: _platform(),
      screenType: _screenType(width),
      deviceType: _deviceType(width),
      category: _category(width, height),
      posture: _posture(width, height),
      orientation: media.orientation,
      inputType: _input(context),

      width: width,
      height: height,

      // ✅ NEW (important)
      aspectRatio: ratio,
      aspectType: _aspectType(ratio),
      devicePixelRatio: dpr,
      densityType: _density(dpr),
    );
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
    if (w < 600) return ScreenType.compact;
    if (w < 840) return ScreenType.medium;
    if (w < 1200) return ScreenType.expanded;
    return ScreenType.large;
  }

  // ---------------- DEVICE TYPE ----------------
  static DeviceType _deviceType(double w) {
    if (w < 600) return DeviceType.phone;
    if (w < 1024) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  // ---------------- CATEGORY ----------------
  static DeviceCategory _category(double w, double h) {
    // 🎯 TV detection
    if (w >= 1200 && h >= 700) {
      return DeviceCategory.tv;
    }

    // 🎯 Foldable hint
    if (w >= 600 && w <= 900) {
      return DeviceCategory.foldable;
    }

    if (w < 600) return DeviceCategory.mobile;
    if (w < 1024) return DeviceCategory.tablet;

    return DeviceCategory.desktop;
  }

  // ---------------- POSTURE ----------------
  static DevicePosture _posture(double w, double h) {
    final ratio = w / h;

    if (w < 400) return DevicePosture.folded;

    if (ratio > 0.7 && ratio < 1.3) {
      return DevicePosture.halfOpened;
    }

    if (w >= 700 && w <= 900) {
      return DevicePosture.unfolded;
    }

    return DevicePosture.normal;
  }

  // ---------------- INPUT TYPE ----------------
  static InputType _input(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    // heuristic: wide screens → mouse likely
    return w > 900 ? InputType.mouseKeyboard : InputType.touch;
  }

  // ---------------- ASPECT RATIO ----------------
  static double _aspectRatio(double w, double h) {
    if (h == 0) return 0;
    return w / h;
  }

  static AspectType _aspectType(double ratio) {
    if (ratio < 0.8) return AspectType.portrait;
    if (ratio > 1.8) return AspectType.ultrawide;
    if (ratio > 1.2) return AspectType.landscape;
    return AspectType.square;
  }

  // ---------------- DENSITY ----------------
  static DensityType _density(double dpr) {
    if (dpr < 1.5) return DensityType.low;
    if (dpr < 2.5) return DensityType.medium;
    if (dpr < 3.5) return DensityType.high;
    return DensityType.ultra;
  }
}
