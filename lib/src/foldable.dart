import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'enums.dart';

/// Represents a foldable device feature like a hinge or cutout.
class FoldFeature {
  /// The bounds of the fold feature on screen.
  final Rect bounds;

  /// Whether this feature is a hinge (folding mechanism).
  final bool isHinge;

  /// The type of display feature.
  final DisplayFeatureType type;

  /// Whether this feature represents a physical separation.
  final bool isSeparating;

  const FoldFeature({
    required this.bounds,
    required this.isHinge,
    required this.type,
    required this.isSeparating,
  });
}

/// Advanced foldable device detection and posture analysis.
class FoldableDetector {
  /// Detects foldable features using hardware display features.
  ///
  /// Returns the most significant fold feature (hinge preferred over cutouts).
  static FoldFeature? detect(BuildContext context) {
    final features = MediaQuery.of(context).displayFeatures;

    // Prioritize hinges over other features
    FoldFeature? hingeFeature;
    FoldFeature? otherFeature;

    for (final f in features) {
      final feature = FoldFeature(
        bounds: f.bounds,
        isHinge: f.type == DisplayFeatureType.hinge,
        type: f.type,
        isSeparating: f.type == DisplayFeatureType.hinge ||
            f.type == DisplayFeatureType.cutout,
      );

      if (f.type == DisplayFeatureType.hinge) {
        hingeFeature = feature;
      } else {
        otherFeature ??= feature;
      }
    }

    return hingeFeature ?? otherFeature;
  }

  /// Checks if the device has foldable hardware features.
  static bool isFoldable(BuildContext context) {
    return detect(context) != null;
  }

  /// Debug information about foldable detection for troubleshooting.
  static Map<String, dynamic> debugInfo(BuildContext context) {
    final features = MediaQuery.of(context).displayFeatures;
    final size = MediaQuery.of(context).size;

    return {
      'displayFeatures': features
          .map((f) => {
                'type': f.type.toString(),
                'bounds': f.bounds.toString(),
              })
          .toList(),
      'screenSize': '${size.width}x${size.height}',
      'aspectRatio': size.width / size.height,
      'foldableDetected': isFoldable(context),
      'likelyPosture':
          getLikelyPosture(context, size.width, size.height).toString(),
    };
  }

  /// Determines the likely posture based on foldable features and screen dimensions.
  ///
  /// This provides a hardware-assisted posture detection that works with
  /// MediaQuery.displayFeatures when available.
  static DevicePosture getLikelyPosture(
      BuildContext context, double width, double height) {
    final feature = detect(context);

    // If no hardware features detected, fall back to heuristics
    if (feature == null) {
      return _heuristicPosture(width, height);
    }

    // Hardware-based posture detection
    final aspectRatio = width / height;

    // Hinge detected - likely a foldable device
    if (feature.isHinge) {
      // Very narrow width suggests folded state
      if (width < 400) {
        return DevicePosture.folded;
      }

      // Square-like aspect ratio suggests half-opened
      if (aspectRatio > 0.7 && aspectRatio < 1.3) {
        return DevicePosture.halfOpened;
      }

      // Reasonable aspect ratio for unfolded state
      if (aspectRatio > 1.2 && aspectRatio < 2.5) {
        return DevicePosture.unfolded;
      }
    }

    return DevicePosture.normal;
  }

  /// Fallback heuristic posture detection when hardware features unavailable.
  static DevicePosture _heuristicPosture(double width, double height) {
    final ratio = width / height;

    if (width < 400) return DevicePosture.folded;
    if (ratio > 0.7 && ratio < 1.3) return DevicePosture.halfOpened;
    if (width >= 700 && width <= 900 && ratio > 1.2) {
      return DevicePosture.unfolded;
    }

    return DevicePosture.normal;
  }

  /// Checks if the device is likely in a dual-screen posture.
  ///
  /// This is useful for determining when to show dual-pane layouts.
  static bool isDualScreenPosture(
      BuildContext context, double width, double height) {
    final feature = detect(context);
    if (feature == null) return false;

    // Check if hinge creates usable separate screens
    final hingeBounds = feature.bounds;
    final totalWidth = width;
    final leftWidth = hingeBounds.left;
    final rightWidth = totalWidth - hingeBounds.right;

    const minPaneWidth = 240; // Minimum usable pane width

    return leftWidth >= minPaneWidth && rightWidth >= minPaneWidth;
  }
}
