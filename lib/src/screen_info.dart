import 'package:flutter/material.dart';
import 'enums.dart';

class ScreenInfo {
  final PlatformType platform;
  final ScreenType screenType;
  final DeviceType deviceType;
  final DeviceCategory category;
  final DevicePosture posture;
  final Orientation orientation;
  final InputType inputType;

  final double aspectRatio;
  final AspectType aspectType;
  final double devicePixelRatio;
  final DensityType densityType;

  final double width;
  final double height;

  const ScreenInfo({
    required this.platform,
    required this.screenType,
    required this.deviceType,
    required this.category,
    required this.posture,
    required this.orientation,
    required this.inputType,
    required this.aspectRatio,
    required this.aspectType,
    required this.devicePixelRatio,
    required this.densityType,
    required this.width,
    required this.height,
  });

  bool get isMobile => deviceType == DeviceType.phone;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isTV => category == DeviceCategory.tv;
  bool get isFoldable => category == DeviceCategory.foldable;

  bool get isWide =>
      screenType == ScreenType.expanded || screenType == ScreenType.large;
}
