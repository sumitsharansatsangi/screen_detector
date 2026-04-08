# screen_detector

A comprehensive Flutter package for adaptive screen detection and responsive layouts, supporting mobile, tablet, desktop, foldable devices, and TV platforms.

## Features

- 🔍 **Comprehensive Detection**: Platform, device type, screen size, aspect ratio, density, and posture detection
- 📱 **Multi-Platform Support**: Android, iOS, Windows, macOS, Linux, Web
- 📺 **Device Category Support**: Mobile, tablet, desktop, TV, foldable, and wearable devices
- 🪟 **Adaptive Layouts**: Responsive breakpoints (compact, medium, expanded, large)
- 🔄 **Hardware-Based Foldable Detection**: Real hinge detection using MediaQuery.displayFeatures
- 🎯 **Smart Extensions**: Built-in adaptive helpers for padding, font scaling, and layout decisions
- 🧭 **Navigation Components**: Adaptive navigation that switches between bottom nav and sidebar
- 📐 **Resolution & Density**: Pixel ratio and density type detection
- 📱 **Advanced Input Detection**: Touch, mouse/keyboard, and hybrid input support
- ⚙️ **Custom Breakpoints**: Configurable screen size thresholds
- 🎬 **Animated Layouts**: Smooth transitions between responsive layouts
- ♿ **Accessibility**: Built-in screen reader support and semantic labels
- 🔧 **Configuration System**: Global settings for detection behavior
- 📊 **Device Capabilities**: Hardware feature detection (HDR, stylus, biometrics)
- ⚡ **Performance Monitoring**: Built-in metrics and optimization
- 🔄 **Async Detection**: Enhanced detection with sensor support
- 📈 **Developer Experience**: Comprehensive testing, CI/CD, and documentation

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  screen_detector: ^0.0.1
```

## Quick Start

Wrap your app with `ScreenProvider`:

```dart
import 'package:screen_detector/screen_detector.dart';

void main() {
  runApp(const ScreenProvider(child: MyApp()));
}
```

Access screen information anywhere in your widget tree:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    return Text(
      'Screen type: ${screen.screenType.name}\n'
      'Device: ${screen.deviceType.name}\n'
      'Platform: ${screen.platform.name}'
    );
  }
}
```

## Adaptive Layout

Use `AdaptiveLayout` for responsive breakpoints:

```dart
AdaptiveLayout(
  compact: MobileLayout(),
  medium: TabletLayout(),
  expanded: DesktopLayout(),
  large: TVLayout(),
)
```

### Custom Breakpoints

Customize breakpoints instead of using Material Design defaults:

```dart
AdaptiveLayout(
  breakpoints: AdaptiveBreakpoints.dense, // Smaller breakpoints
  compact: MobileLayout(),
  medium: TabletLayout(),
  expanded: DesktopLayout(),
)

// Or create custom breakpoints
final customBreakpoints = AdaptiveBreakpoints(
  compact: 500,
  medium: 800,
  expanded: 1200,
  large: 1600,
);
```

### Animated Layouts

For smooth transitions between breakpoints:

```dart
AnimatedAdaptiveLayout(
  compact: MobileLayout(),
  medium: TabletLayout(),
  expanded: DesktopLayout(),
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
)
```

The widget automatically selects the appropriate layout based on screen size:
- **compact**: Phones in portrait
- **medium**: Tablets, phones in landscape
- **expanded**: Desktop windows
- **large**: TV screens, ultra-wide displays

## Adaptive Navigation

`AdaptiveNavigation` automatically switches between navigation patterns with built-in accessibility:

```dart
AdaptiveNavigation(
  selectedIndex: selectedIndex,
  onDestinationSelected: (index) => setState(() => selectedIndex = index),
  destinations: [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  body: YourContent(),
  semanticLabel: 'Main app navigation', // For screen readers
)
```

- Uses bottom navigation on compact screens
- Uses sidebar navigation on medium+ screens
- Includes semantic labels for accessibility

## Screen Information

Access comprehensive screen data:

```dart
final screen = context.screen;

print('Resolution: ${screen.width}x${screen.height}');
print('Aspect ratio: ${screen.aspectRatio}');
print('Device pixel ratio: ${screen.devicePixelRatio}');
print('Posture: ${screen.posture.name}');
print('Is foldable: ${screen.isFoldable}');
print('Is watch: ${screen.isWatch}');
print('Is wearable: ${screen.isWearable}');
print('Input type: ${screen.inputType.name}');
print('Is hybrid input: ${screen.isHybridInput}');
print('Supports touch: ${screen.supportsTouch}');
print('Supports mouse/keyboard: ${screen.supportsMouseKeyboard}');
print('Adaptive padding: ${screen.adaptivePadding}');
print('Adaptive icon size: ${screen.adaptiveIconSize}');
```

## Available Extensions

### ScreenInfo Extensions

```dart
final screen = context.screen;

// Layout helpers
bool useSidebar = screen.useSidebar;        // true for wide screens
bool useBottomNav = screen.useBottomNav;    // true for compact screens
int gridColumns = screen.gridColumns;        // 1-4 based on screen size

// Advanced UI helpers
bool isUltrawide = screen.isUltrawide;
bool isLandscape = screen.isLandscape;
bool isHighDensity = screen.isHighDensity;
double adaptivePadding = screen.adaptivePadding;     // 12-24 based on device
double adaptiveFontScale = screen.adaptiveFontScale; // 0.9-1.1 based on density
```

## Foldable Device Support

Advanced foldable device detection using hardware features:

```dart
// Detect hardware foldable features
final hinge = FoldableDetector.detect(context);

// Hardware-assisted posture detection
final posture = FoldableDetector.getLikelyPosture(context, screen.width, screen.height);

// Check for dual-screen capability
final isDualScreen = FoldableDetector.isDualScreenPosture(context, screen.width, screen.height);

if (hinge != null && isDualScreen) {
  // Device supports dual-screen layout
  return HingeSplitLayout(
    left: LeftPaneContent(),
    right: RightPaneContent(),
  );
}
```

## Watch & Wearable Support

The package includes comprehensive support for smartwatches and wearable devices:

```dart
// Detect watch devices
if (screen.isWatch) {
  // Use minimal UI for watches
  return WatchLayout(
    padding: screen.adaptivePadding, // 4px for watches
    iconSize: screen.adaptiveIconSize, // 16px for watches
    buttonHeight: screen.adaptiveButtonHeight, // 32px for watches
  );
}

// Check for wearable category
if (screen.isWearable) {
  // Wearable-specific optimizations
}

// Use minimal UI helpers
if (screen.isMinimalUI) {
  // Simplified interface for small screens
}
```

## Hybrid Input Support

The package intelligently detects devices that support multiple input methods:

```dart
// Detect hybrid devices (touch + mouse/keyboard)
if (screen.isHybridInput) {
  // Show both touch-friendly and mouse-friendly UI elements
  return HybridLayout(
    touchControls: TouchControls(),
    mouseControls: MouseControls(),
  );
}

// Check specific input capabilities
if (screen.supportsTouch) {
  // Include touch gestures and large touch targets
}

if (screen.supportsMouseKeyboard) {
  // Include hover effects, keyboard shortcuts, precise controls
}
```

## Configuration & Performance

Configure global detection behavior:

```dart
// Performance-optimized configuration
ScreenDetector.configure(ScreenDetectorConfig.performance);

// Debug configuration with logging
ScreenDetector.configure(ScreenDetectorConfig.debug);

// Custom configuration
ScreenDetector.configure(ScreenDetectorConfig(
  enableHardwareAcceleration: true,
  enableSensorDetection: false,
  breakpoints: AdaptiveBreakpoints.dense,
  cacheDurationMs: 100,
  debugMode: true,
));
```

Monitor detection performance:

```dart
final screen = context.screen;
// Detection metrics are automatically collected
final metrics = PerformanceMonitor.lastMetrics;
print('Detection took: ${metrics?.detectionTimeUs} microseconds');
```

## Device Capabilities

Detect specific hardware features:

```dart
final capabilities = screen.capabilities;

if (capabilities.hasHDRDisplay) {
  // Use HDR-optimized colors
}

if (capabilities.hasStylusSupport) {
  // Enable stylus-specific features
}

if (capabilities.hasBiometricAuth) {
  // Show biometric authentication options
}

if (capabilities.hasHighRefreshRate) {
  // Enable smooth animations
}
```

## Async Detection

Use enhanced async detection for better performance:

```dart
// Basic sync detection
final screen = ScreenDetector.of(context);

// Enhanced async detection with sensor support
final enhancedScreen = await ScreenDetector.detectAsync(context);

// Reactive screen changes (future implementation)
ScreenDetector.screenChanges(context).listen((screen) {
  // Handle screen changes reactively
  updateUI(screen);
});
```

// Adaptive UI based on primary input method
switch (screen.inputType) {
  case InputType.touch:
    return TouchOptimizedUI();
  case InputType.mouseKeyboard:
    return DesktopOptimizedUI();
  case InputType.hybrid:
    return UniversalUI(); // Works with both input methods
}
```

## Enums and Types

### PlatformType
- `android`, `ios`, `windows`, `macos`, `linux`, `web`, `unknown`

### DeviceType
- `phone`, `tablet`, `desktop`, `watch`, `unknown`

### DeviceCategory
- `mobile`, `tablet`, `desktop`, `tv`, `foldable`, `wearable`

### ScreenType (Breakpoints)
- `compact`: < 600dp width
- `medium`: 600-839dp width
- `expanded`: 840-1199dp width
- `large`: ≥ 1200dp width

### DevicePosture
- `normal`, `folded`, `halfOpened`, `unfolded`

### AspectType
- `portrait`, `landscape`, `square`, `ultrawide`

### DensityType
- `low` (< 1.5), `medium` (1.5-2.5), `high` (2.5-3.5), `ultra` (> 3.5)

### InputType
- `touch`, `mouseKeyboard`, `hybrid` (supports both touch and mouse/keyboard)

## Example App

Run the example app to see all features in action:

```bash
cd example
flutter run
```

The example app includes three demo pages:

1. **Calendar Demo**: Responsive calendar layout with foldable support
2. **Info Display**: Comprehensive screen detection information
3. **Advanced Features**: Interactive demo of all new features including:
   - Custom breakpoints configuration
   - Animated layout transitions
   - Hardware foldable detection
   - Accessibility features
   - Real-time screen information updates

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.</content>
<parameter name="filePath">README.md