import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer_app/features/home/home_screen.dart';
import 'package:customer_app/features/home/swappable_dashboard/views/swappable_dashboard.dart';
import 'package:customer_app/features/banking/banking_provider.dart';
import 'package:customer_app/features/auth/providers/auth_provider.dart';
import 'package:customer_app/features/auth/models/user_persona.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('HomeScreen renders DashboardArea with default widgets', (
    WidgetTester tester,
  ) async {
    // Mock Transaction Data
    final mockTransactions = [
      Transaction(
        id: '1',
        title: 'Coffee',
        subtitle: 'Cafe',
        amount: 5.50,
        date: DateTime.now(),
        isDebit: true,
      ),
    ];
    final mockAccount = Account(
      id: '1',
      name: 'Main',
      balance: 1250.00,
      accountNumber: '**** 1234',
    );

    final mockPersona = UserPersona(
      id: 'check',
      name: 'Test User',
      segment: 'Test Segment',
      description: 'Test Description',
      avatarChar: 'T',
      preferredMarketplaceCategory: 'Test',
      showPersonalizedDashboard: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Provide dummy user state. Check if authProvider is a StateNotifier or just a provider. It's likely a StateNotifierProvider<AuthNotifier, UserPersona?>
          // We can override the notifier or the state if it allows.
          // If it's a StateNotifierProvider, we override it with a mock notifier or state.
          // Assuming StateNotifierProvider<AuthNotifier, UserPersona?>:
          authProvider.overrideWith(() => MockAuthNotifier(mockPersona)),

          // Provide dummy banking data
          transactionsProvider.overrideWith(
            (ref) => Future.value(mockTransactions),
          ),
          accountProvider.overrideWith((ref) => Stream.value(mockAccount)),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Header
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);

    // Verify DashboardArea exist
    expect(find.byType(DashboardArea), findsOneWidget);

    // Verify Widgets from default state (Balance, Life Events, Transactions, Services)
    expect(
      find.text('Current Account'),
      findsOneWidget,
    ); // Balance Widget Title
    expect(find.text('Up Next'), findsOneWidget);
    expect(
      find.text('Recent Activity'),
      findsOneWidget,
    ); // Transactions Widget Title
    expect(find.text('Chat'), findsOneWidget);

    // Check content inside widgets
    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('\$1,250.00'), findsOneWidget);

    // Verify Customize Button
    expect(find.text('Customize'), findsOneWidget);

    // Tap Customize
    await tester.tap(find.text('Customize'));
    await tester.pump(const Duration(milliseconds: 500));

    // Allow async operations to complete
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Expect visuals to change (Unlock mode)
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Add Row'), findsOneWidget);
  });
  testWidgets('Dashboard interactions: Add Row and Unlock', (
    WidgetTester tester,
  ) async {
    final mockTransactions = <Transaction>[];
    final mockAccount = Account(
      id: '1',
      name: 'Main',
      balance: 1000.0,
      accountNumber: '1234',
    );
    final mockPersona = UserPersona(
      id: 'check',
      name: 'Test User',
      segment: 'Test Segment',
      description: 'Test Description',
      avatarChar: 'T',
      preferredMarketplaceCategory: 'Test',
      showPersonalizedDashboard: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => MockAuthNotifier(mockPersona)),
          transactionsProvider.overrideWith(
            (ref) => Future.value(mockTransactions),
          ),
          accountProvider.overrideWith((ref) => Stream.value(mockAccount)),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    // Verify initial locked state
    expect(find.text('Add Row'), findsNothing);

    // Tap Customize to unlock
    await tester.tap(find.text('Customize'));
    await tester.pump(const Duration(seconds: 1));

    // Verify unlocked state
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Add Row'), findsOneWidget);

    // Tap Add Row
    final addRowFinder = find.text('Add Row');
    await tester.scrollUntilVisible(addRowFinder, 500.0);
    await tester.tap(addRowFinder);
    await tester.pump(const Duration(seconds: 1));

    // Should see more slots (implementation detail: default row has 4 slots or logic determines it)
    // We can at least check that we are still in unlocked mode
    expect(find.text('Done'), findsOneWidget);

    // Tap Done to lock
    await tester.tap(find.text('Done'));
    await tester.pump(const Duration(seconds: 1));

    // Verify locked state again
    expect(find.text('Add Row'), findsNothing);
  });
}

// Mock Notifier
class MockAuthNotifier extends AuthNotifier {
  final UserPersona? _initialState;
  MockAuthNotifier(this._initialState) : super();

  @override
  UserPersona? build() {
    return _initialState;
  }
}
