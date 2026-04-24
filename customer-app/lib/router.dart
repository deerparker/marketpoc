import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';
import 'features/payments/payments_screen.dart';
import 'features/help/help_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/home_shell.dart';
import 'features/banking/banking_screen.dart';
import 'features/marketplace/marketplace_screen.dart';
import 'features/marketplace/marketplace_provider.dart';
import 'features/marketplace/product_detail_screen.dart';
import 'features/marketplace/seller_screen.dart';
import 'features/marketplace/cart/cart_screen.dart';
import 'features/auth/profile_screen.dart';
import 'features/auth/marketplace_settings_screen.dart';
import 'features/financial_events/screens/add_event_screen.dart';
import 'features/financial_events/screens/event_dashboard_screen.dart';
import 'features/financial_events/screens/event_setup_screen.dart';
import 'features/financial_events/models/financial_event.dart'; // Import for type cast
import 'features/banking/bank_products/screens/bank_products_screen.dart';
import 'features/banking/bank_products/screens/product_setup_screen.dart';
import 'features/banking/bank_products/screens/owned_product_detail_screen.dart';
import 'features/banking/bank_products/models/bank_product.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) {
    // We need to access the provider via a context-less way or pass ref to router
    // Ideally, we'd use a Listenable for the router to refresh.
    // For this simple implementation, we'll assume the provider state is accessible via a global scope or
    // passed in. However, since we can't easily change the router construction to be dynamic
    // without a larger refactor in main.dart, we will rely on manual navigation from Login
    // and a simple check here if possible.
    // better: let's update main.dart to provide the router with a listenable.
    // For now, let's just add the route and initial location.
    // The LoginScreen handles the push to /home.
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeShell(navigationShell: navigationShell);
      },
      branches: [
        // 1. Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // 2. Payments
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/payments',
              builder: (context, state) => const PaymentsScreen(),
            ),
          ],
        ),
        // 3. Products (formerly Banking)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/banking',
              builder: (context, state) => const BankingScreen(),
              routes: [
                GoRoute(
                  path: 'add-event',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AddEventScreen(),
                  routes: [
                    GoRoute(
                      path: 'setup',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final template = state.extra as FinancialEvent;
                        return EventSetupScreen(template: template);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'event/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final eventId = state.pathParameters['id']!;
                    return EventDashboardScreen(eventId: eventId);
                  },
                ),
                GoRoute(
                  path: 'bank-products', // Relative path under /banking
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const BankProductsScreen(),
                  routes: [
                    GoRoute(
                      path: 'setup',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final product = state.extra as BankProduct;
                        return ProductSetupScreen(product: product);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'my-products/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final productId =
                        int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    return OwnedProductDetailScreen(productId: productId);
                  },
                ),
              ],
            ),
          ],
        ),
        // 4. Marketplace
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/marketplace',
              builder: (context, state) => const MarketplaceScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final product = state.extra as Product;
                    return ProductDetailScreen(product: product);
                  },
                ),
                GoRoute(
                  path: 'seller/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final seller = state.extra as Seller?;
                    return SellerScreen(sellerId: id, sellerExtra: seller);
                  },
                ),
              ],
            ),
          ],
        ),
        // 5. Help
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/help',
              builder: (context, state) => const HelpScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/cart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
      routes: [
        GoRoute(
          path: 'marketplace-settings',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const MarketplaceSettingsScreen(),
        ),
      ],
    ),
  ],
);
