import 'package:flutter/material.dart';

import 'enums.dart';
import 'screen_provider.dart';

class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget body;

  const AdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    // 📱 Mobile → Bottom Nav
    if (screen.screenType == ScreenType.compact) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      );
    }

    // 📲 Tablet → Navigation Rail
    if (screen.screenType == ScreenType.medium) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations
                  .map((e) => NavigationRailDestination(
                        icon: e.icon,
                        label: Text(e.label),
                      ))
                  .toList(),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    // 🖥 Desktop → Sidebar
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
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
          Expanded(child: body),
        ],
      ),
    );
  }
}
