import 'package:buddies_and_sports/router/route_names.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (value) => _onItemTapped(value, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: UserText.Discover,
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: UserText.Buddies,
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: UserText.Profile,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: UserText.Settings,
          ),
        ],
      ),
    );
  }

  static int _getSelectedIndex(BuildContext context) {
    String location = GoRouterState.of(context).location;
    if (location.contains(Routes.discover)) {
      return 0;
    }
    if (location.contains(Routes.buddies)) {
      return 1;
    }
    if (location.contains(Routes.profile)) {
      return 2;
    }
    if (location.contains(Routes.settings)) {
      return 3;
    }

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(Routes.discover);
        break;
      case 1:
        context.go(Routes.buddies);
        break;
      case 2:
        context.go(Routes.profile);
        break;
      case 3:
        context.go(Routes.settings);
        break;
    }
  }
}
