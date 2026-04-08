import 'package:flutter/material.dart';

import 'enums.dart';
import 'screen_provider.dart';

/// A navigation widget that adapts between bottom navigation and sidebar based on screen size.
///
/// On compact screens (< 600dp), displays a bottom [NavigationBar].
/// On medium screens (600-839dp), displays a side [NavigationRail].
/// On expanded/large screens (≥ 840dp), displays an extended [NavigationRail].
///
/// Includes built-in accessibility features with semantic labels for screen readers.
///
/// Example:
/// ```dart
/// AdaptiveNavigation(
///   selectedIndex: selectedIndex,
///   onDestinationSelected: (index) => setState(() => selectedIndex = index),
///   destinations: [
///     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
///     NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
///   ],
///   body: YourContent(),
///   semanticLabel: 'Main app navigation',
/// )
/// ```
class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget body;

  /// Semantic label for the navigation component.
  final String? semanticLabel;

  const AdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    // 📱 Mobile → Bottom Nav
    if (screen.screenType == ScreenType.compact) {
      return Scaffold(
        body: Semantics(
          label: semanticLabel ??
              'Bottom navigation with ${destinations.length} destinations',
          child: body,
        ),
        bottomNavigationBar: Semantics(
          label: semanticLabel ?? 'Bottom navigation',
          container: true,
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
          ),
        ),
      );
    }

    // 📲 Tablet → Navigation Rail
    if (screen.screenType == ScreenType.medium) {
      return Scaffold(
        body: Row(
          children: [
            Semantics(
              label: semanticLabel ?? 'Side navigation rail',
              container: true,
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                destinations: destinations
                    .map((e) => NavigationRailDestination(
                          icon: e.icon,
                          label: Text(e.label),
                        ))
                    .toList(),
              ),
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
    return Scaffold(
      body: Row(
        children: [
          Semantics(
            label: semanticLabel ?? 'Extended side navigation',
            container: true,
            child: NavigationRail(
              extended: true,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations
                  .map((e) => NavigationRailDestination(
                        icon: e.icon,
                        label: Text(e.label),
                      ))
                  .toList(),
            ),
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
