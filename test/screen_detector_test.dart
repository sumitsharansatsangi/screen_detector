import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_detector/screen_detector.dart';

void main() {
  group('ScreenDetector', () {
    testWidgets('detects compact screen type', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ScreenProvider(
          child: SizedBox.shrink(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      final screen = ScreenDetector.of(context);

      expect(screen.screenType, ScreenType.compact);
      expect(screen.deviceType, DeviceType.phone);
    });

    testWidgets('calculates aspect ratio correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ScreenProvider(
          child: SizedBox.shrink(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      final screen = ScreenDetector.of(context);

      expect(screen.aspectRatio, closeTo(1.333, 0.001));
      expect(screen.aspectType, AspectType.landscape);
    });

    testWidgets('detects watch device type', (tester) async {
      tester.view.physicalSize = const Size(200, 200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ScreenProvider(
          child: SizedBox.shrink(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      final screen = ScreenDetector.of(context);

      expect(screen.deviceType, DeviceType.watch);
      expect(screen.category, DeviceCategory.wearable);
      expect(screen.isWatch, true);
      expect(screen.isWearable, true);
    });

    testWidgets('detects hybrid input type for tablets', (tester) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ScreenProvider(
          child: SizedBox.shrink(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      final screen = ScreenDetector.of(context);

      expect(screen.deviceType, DeviceType.tablet);
      expect(screen.inputType, InputType.hybrid);
      expect(screen.isHybridInput, true);
    });

    testWidgets('detects foldable category by screen size', (tester) async {
      // Foldable size range: 600-900px width
      tester.view.physicalSize = const Size(750, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ScreenProvider(
          child: SizedBox.shrink(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      final screen = ScreenDetector.of(context);

      expect(screen.category, DeviceCategory.foldable);
      expect(screen.isFoldable, true);
    });
  });

  group('AdaptiveLayout', () {
    testWidgets('shows compact layout on small screens', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ScreenProvider(
          child: AdaptiveLayout(
            compact: Container(key: const Key('compact')),
            medium: Container(key: const Key('medium')),
          ),
        ),
      );

      expect(find.byKey(const Key('compact')), findsOneWidget);
      expect(find.byKey(const Key('medium')), findsNothing);
    });
  });
}
