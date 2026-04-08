import 'package:flutter/material.dart';
import 'package:screen_detector/screen_detector.dart';

class HingeSplitLayout extends StatelessWidget {
  final Widget left;
  final Widget right;

  const HingeSplitLayout({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    final hinge = FoldableDetector.detect(context);

    // ✅ No hinge → normal split
    if (hinge == null) {
      return Row(
        children: [
          Expanded(child: left),
          Expanded(child: right),
        ],
      );
    }

    final bounds = hinge.bounds;
    final totalWidth = MediaQuery.of(context).size.width;

    final leftWidth = bounds.left;
    final hingeWidth = bounds.width;
    final rightWidth = totalWidth - bounds.right;

    // ✅ Prevent unusable tiny panes
    const minPaneWidth = 240;

    if (leftWidth < minPaneWidth || rightWidth < minPaneWidth) {
      return Row(
        children: [
          Expanded(child: left),
          Expanded(child: right),
        ],
      );
    }

    return Row(
      children: [
        // LEFT SCREEN
        SizedBox(width: leftWidth, child: left),

        // HINGE GAP (empty space)
        SizedBox(width: hingeWidth),

        // RIGHT SCREEN
        SizedBox(width: rightWidth, child: right),
      ],
    );
  }
}
