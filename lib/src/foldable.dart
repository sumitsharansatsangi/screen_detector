import 'dart:ui';

import 'package:flutter/widgets.dart';

class FoldFeature {
  final Rect bounds;
  final bool isHinge;

  FoldFeature({
    required this.bounds,
    required this.isHinge,
  });
}

class FoldableDetector {
  static FoldFeature? detect(BuildContext context) {
    final features = MediaQuery.of(context).displayFeatures;

    for (final f in features) {
      if (f.type == DisplayFeatureType.hinge) {
        return FoldFeature(
          bounds: f.bounds,
          isHinge: true,
        );
      }
    }

    return null;
  }

  static bool isFoldable(BuildContext context) {
    return detect(context) != null;
  }
}
