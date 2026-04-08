import 'package:flutter/material.dart';
import 'package:screen_detector/screen_detector.dart';

class AdvancedFeaturesPage extends StatefulWidget {
  const AdvancedFeaturesPage({super.key});

  @override
  State<AdvancedFeaturesPage> createState() => _AdvancedFeaturesPageState();
}

class _AdvancedFeaturesPageState extends State<AdvancedFeaturesPage> {
  bool debugMode = false;

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Features Demo'),
        actions: [
          IconButton(
            icon: Icon(
              debugMode ? Icons.bug_report : Icons.bug_report_outlined,
            ),
            onPressed: () => setState(() => debugMode = !debugMode),
            tooltip: 'Toggle Debug Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screen.adaptivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentConfig(),
            const SizedBox(height: 24),
            _buildDemoLayout(),
            const SizedBox(height: 24),
            _buildFoldableDemo(),
            const SizedBox(height: 24),
            _buildAccessibilityDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentConfig() {
    final screen = context.screen;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Screen Type: ${screen.screenType.name}'),
            Text('Device Type: ${screen.deviceType.name}'),
            Text(
              'Resolution: ${screen.width.toInt()} × ${screen.height.toInt()}',
            ),
            Text('Aspect Ratio: ${screen.aspectRatio.toStringAsFixed(2)}'),
            Text('Posture: ${screen.posture.name}'),
            Text('Is Foldable: ${screen.isFoldable}'),
            // Text('Custom Breakpoints: $useCustomBreakpoints'),
            // Text('Animated Layout: $useAnimatedLayout'),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoLayout() {
    // Simplified layout demo - using basic AdaptiveLayout
    final layout = AdaptiveLayout(
      compact: _buildLayoutCard('Compact Layout', Colors.blue),
      medium: _buildLayoutCard('Medium Layout', Colors.green),
      expanded: _buildLayoutCard('Expanded Layout', Colors.orange),
      large: _buildLayoutCard('Large Layout', Colors.red),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Layout Demo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        layout,
      ],
    );
  }

  Widget _buildLayoutCard(String title, Color color) {
    return Card(
      color: color.withAlpha(26),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildFoldableDemo() {
    final hinge = FoldableDetector.detect(context);
    // final isDualScreen = FoldableDetector.isDualScreenPosture(
    //   context,
    //   screen.width,
    //   screen.height,
    // );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foldable Device Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Hardware Hinge Detected: ${hinge != null}'),
            Text(
              'Display Features Count: ${MediaQuery.of(context).displayFeatures.length}',
            ),
            Text(
              'Screen Size: ${MediaQuery.of(context).size.width.toInt()}x${MediaQuery.of(context).size.height.toInt()}',
            ),
            if (debugMode) ...[
              Text(
                'Display Features: ${MediaQuery.of(context).displayFeatures.map((f) => f.type.toString()).join(', ')}',
              ),
              Text(
                'Foldable Size Check: ${MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width <= 900}',
              ),
            ],
            if (hinge != null) ...[
              Text('Hinge Bounds: ${hinge.bounds}'),
              // Text('Is Separating: ${hinge.isSeparating}'),
            ],
            // Text(
            //   'Likely Posture: ${FoldableDetector.getLikelyPosture(context, screen.width, screen.height).name}',
            // ),
            // Text('Dual Screen Posture: $isDualScreen'),
            const SizedBox(height: 8),
            // if (isDualScreen && hinge != null)
            const Text(
              'This device supports dual-screen layouts!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accessibility Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This app includes semantic labels for screen readers. '
              'Try using a screen reader to navigate the interface.',
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Example accessible button',
              hint: 'This demonstrates accessibility features',
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Accessible Button'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
