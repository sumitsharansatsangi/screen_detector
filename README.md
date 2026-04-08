# screen_detector

A comprehensive Flutter package for adaptive screen detection and responsive layouts, supporting mobile, tablet, desktop, foldable devices, and TV platforms.

## Features

- 🔍 **Comprehensive Detection**: Platform, device type, screen size, aspect ratio, density, and posture detection
- 📱 **Multi-Platform Support**: Android, iOS, Windows, macOS, Linux, Web
- 📺 **Device Category Support**: Mobile, tablet, desktop, TV, and foldable devices
- 🪟 **Adaptive Layouts**: Responsive breakpoints (compact, medium, expanded, large)
- 🔄 **Foldable Awareness**: Detects device posture (normal, folded, half-opened, unfolded)
- 🎯 **Smart Extensions**: Built-in adaptive helpers for padding, font scaling, and layout decisions
- 🧭 **Navigation Components**: Adaptive navigation that switches between bottom nav and sidebar
- 📐 **Resolution & Density**: Pixel ratio and density type detection
- 📱 **Input Type Detection**: Touch vs mouse/keyboard interfaces

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
  compact: (context, constraints) => MobileLayout(),
  medium: (context, constraints) => TabletLayout(),
  expanded: (context, constraints) => DesktopLayout(),
  large: (context, constraints) => TVLayout(),
)
```

The widget automatically selects the appropriate layout based on screen size:
- **compact**: Phones in portrait
- **medium**: Tablets, phones in landscape
- **expanded**: Desktop windows
- **large**: TV screens, ultra-wide displays

## Adaptive Navigation

`AdaptiveNavigation` automatically switches between navigation patterns:

```dart
AdaptiveNavigation(
  selectedIndex: selectedIndex,
  onDestinationSelected: (index) => setState(() => selectedIndex = index),
  destinations: [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  body: YourContent(),
)
```

- Uses bottom navigation on compact screens
- Uses sidebar navigation on medium+ screens

## Screen Information

Access comprehensive screen data:

```dart
final screen = context.screen;

print('Resolution: ${screen.width}x${screen.height}');
print('Aspect ratio: ${screen.aspectRatio}');
print('Device pixel ratio: ${screen.devicePixelRatio}');
print('Posture: ${screen.posture.name}');
print('Is foldable: ${screen.isFoldable}');
print('Input type: ${screen.inputType.name}');
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

Detect and respond to foldable device states:

```dart
final hinge = FoldableDetector.detect(context);

if (hinge != null && screen.posture == DevicePosture.unfolded) {
  // Device is unfolded - use dual-screen layout
  return HingeSplitLayout(
    left: LeftPaneContent(),
    right: RightPaneContent(),
  );
}
```

## Enums and Types

### PlatformType
- `android`, `ios`, `windows`, `macos`, `linux`, `web`, `unknown`

### DeviceType
- `phone`, `tablet`, `desktop`, `unknown`

### DeviceCategory
- `mobile`, `tablet`, `desktop`, `tv`, `foldable`

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
- `touch`, `mouseKeyboard`

## Example App

Run the example app to see all features in action:

```bash
cd example
flutter run
```

The example demonstrates:
- Responsive calendar layout
- Adaptive navigation
- Foldable device support
- Comprehensive screen information display

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.</content>
<parameter name="filePath">README.md