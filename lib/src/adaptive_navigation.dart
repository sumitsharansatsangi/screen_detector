import 'package:flutter/widgets.dart';

import 'enums.dart';
import 'screen_provider.dart';

/// Represents a destination in the adaptive navigation.
class AdaptiveNavigationDestination {
  /// The icon to display for this destination.
  final Icon icon;

  /// The label to display for this destination.
  final String label;

  const AdaptiveNavigationDestination({
    required this.icon,
    required this.label,
  });
}

/// A navigation widget that adapts between bottom navigation and sidebar based on screen size.
///
/// On compact screens (< 600dp), displays a custom bottom navigation bar.
/// On medium screens (600-839dp), displays a custom side navigation rail.
/// On expanded/large screens (≥ 840dp), displays an extended custom side navigation rail.
///
/// Includes built-in accessibility features with semantic labels for screen readers.
///
/// Example:
/// ```dart
/// AdaptiveNavigation(
///   selectedIndex: selectedIndex,
///   onDestinationSelected: (index) => setState(() => selectedIndex = index),
///   destinations: [
///     AdaptiveNavigationDestination(icon: Icon(Icons.home), label: 'Home'),
///     AdaptiveNavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
///   ],
///   body: YourContent(),
///   semanticLabel: 'Main app navigation',
///   selectedColor: Colors.blue,
///   unselectedColor: Colors.grey,
///   backgroundColor: Colors.white,
///   borderColor: Colors.grey.shade300,
/// )
/// ```
class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveNavigationDestination> destinations;
  final Widget body;

  /// Semantic label for the navigation component.
  final String? semanticLabel;

  /// Color for selected navigation items.
  final Color selectedColor;

  /// Color for unselected navigation items.
  final Color unselectedColor;

  /// Background color for navigation areas.
  final Color backgroundColor;

  /// Border color for navigation areas.
  final Color borderColor;

  const AdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.semanticLabel,
    this.selectedColor = const Color(0xFF2196F3),
    this.unselectedColor = const Color(0xFF9E9E9E),
    this.backgroundColor = const Color(0xFFF8F8F8),
    this.borderColor = const Color(0xFFE0E0E0),
  });

  Widget _buildBottomNav(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(destinations.length, (index) {
            final dest = destinations[index];
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onDestinationSelected(index),
                child: Semantics(
                  label:
                      '${dest.label}, ${isSelected ? 'selected' : 'not selected'}',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (dest.icon).icon,
                        color: isSelected ? selectedColor : unselectedColor,
                      ),
                      Text(
                        dest.label,
                        style: TextStyle(
                          color: isSelected ? selectedColor : unselectedColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildRail(BuildContext context, bool extended) {
    return SizedBox(
      width: extended ? 200.0 : 72.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(right: BorderSide(color: borderColor)),
        ),
        child: Column(
          children: List.generate(destinations.length, (index) {
            final dest = destinations[index];
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onDestinationSelected(index),
              child: Semantics(
                label:
                    '${dest.label}, ${isSelected ? 'selected' : 'not selected'}',
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        (dest.icon).icon,
                        color: isSelected ? selectedColor : unselectedColor,
                      ),
                      if (extended) ...[
                        const SizedBox(width: 16),
                        Text(
                          dest.label,
                          style: TextStyle(
                            color: isSelected ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    // 📱 Mobile → Bottom Nav
    if (screen.screenType == ScreenType.compact) {
      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Semantics(
                label: semanticLabel ?? 'Main content area',
                child: body,
              ),
            ),
            Semantics(
              label: semanticLabel ?? 'Bottom navigation',
              container: true,
              child: _buildBottomNav(context),
            ),
          ],
        ),
      );
    }

    // 📲 Tablet → Navigation Rail
    if (screen.screenType == ScreenType.medium) {
      return SafeArea(
        child: Row(
          children: [
            Semantics(
              label: semanticLabel ?? 'Side navigation rail',
              container: true,
              child: _buildRail(context, false),
            ),
            Expanded(
              child: Semantics(
                label: 'Main content area',
                child: body,
              ),
            ),
          ],
        ),
      );
    }

    // 🖥 Desktop → Sidebar
    return SafeArea(
      child: Row(
        children: [
          Semantics(
            label: semanticLabel ?? 'Extended side navigation',
            container: true,
            child: _buildRail(context, true),
          ),
          Expanded(
            child: Semantics(
              label: 'Main content area',
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
