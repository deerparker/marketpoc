import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/privacy_settings_provider.dart';

class HomeShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacySettings = ref.watch(privacySettingsProvider);

    return privacySettings.when(
      data: (settings) {
        // Build destinations list based on marketplace setting
        final destinations = <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: 'Payments',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Products',
          ),
          if (settings.marketplaceEnabled)
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Marketplace',
            ),
          const NavigationDestination(
            icon: Icon(Icons.help_outline),
            selectedIcon: Icon(Icons.help),
            label: 'Help',
          ),
        ];

        // Adjust index if marketplace is disabled and we're beyond that point
        int adjustedIndex = navigationShell.currentIndex;
        if (!settings.marketplaceEnabled && navigationShell.currentIndex >= 3) {
          // Marketplace was at index 3, so indices 3+ need to shift down
          adjustedIndex = navigationShell.currentIndex - 1;
        }

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: adjustedIndex,
            onDestinationSelected: (index) {
              // Adjust the branch index back if marketplace is disabled
              int targetBranch = index;
              if (!settings.marketplaceEnabled && index >= 3) {
                // We need to skip the marketplace branch (index 3)
                targetBranch = index + 1;
              }

              navigationShell.goBranch(
                targetBranch,
                initialLocation: targetBranch == navigationShell.currentIndex,
              );
            },
            destinations: destinations,
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) {
        // Fallback to showing all tabs if settings fail to load
        final destinations = <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: 'Payments',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Products',
          ),
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Marketplace',
          ),
          const NavigationDestination(
            icon: Icon(Icons.help_outline),
            selectedIcon: Icon(Icons.help),
            label: 'Help',
          ),
        ];

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: destinations,
          ),
        );
      },
    );
  }
}
