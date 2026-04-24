import 'package:customer_app/core/database/app_database.dart';
import 'package:customer_app/features/home/widgets/profile_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:customer_app/features/auth/providers/auth_provider.dart';
import 'view_preferences_provider.dart';
import '../financial_events/providers/financial_events_provider.dart';
import '../financial_events/models/financial_event.dart';
import 'bank_products/providers/owned_products_provider.dart';

class BankingScreen extends ConsumerWidget {
  const BankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persona = ref.watch(authProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Products'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              const SizedBox(width: 8),
              const ProfileIconButton(),
              const SizedBox(width: 16),
            ],
          ),

          // Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you today?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (persona != null)
                    Text(
                      'Based on your profile as a ${persona.segment}, here are some suggestions.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          ),

          // Active Life Events Section (Personalized)
          const SliverToBoxAdapter(child: _LifeEventsSection()),

          // Browse Products Button (New)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to a generic products list or just scroll down
                  // For now, just a visual element as per requirements
                  context.push('/banking/bank-products');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Just let me look at products'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),

          // Owned Products Section
          const SliverToBoxAdapter(child: _BankProductsSection()),
        ],
      ),
    );
  }
}

class _LifeEventsSection extends ConsumerWidget {
  const _LifeEventsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(financialEventsProvider);
    final viewMode = ref.watch(lifeEventsViewModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Life Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  // View mode toggle
                  IconButton(
                    icon: Icon(
                      viewMode == ViewMode.list
                          ? Icons.grid_view
                          : Icons.view_list,
                      size: 20,
                    ),
                    onPressed: () {
                      ref.read(lifeEventsViewModeProvider.notifier).toggle();
                    },
                    tooltip: viewMode == ViewMode.list
                        ? 'Switch to grid'
                        : 'Switch to list',
                  ),
                  eventsAsync.maybeWhen(
                    data: (events) => events.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => context.go('/banking/add-event'),
                          )
                        : const SizedBox.shrink(),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        ),
        eventsAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => context.go('/banking/add-event'),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 32, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Add a Life Goal',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (viewMode == ViewMode.list) {
              return _buildListView(context, ref, events);
            } else {
              return _buildGridView(context, ref, events);
            }
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text('Error loading events')),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    List<FinancialEvent> events,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: events.map((event) {
          final progress = event.selectedTodos.isEmpty
              ? 0.0
              : event.selectedTodos.where((t) => t.isCompleted).length /
                    event.selectedTodos.length;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => context.go('/banking/event/${event.id}'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  _getIconForType(event.type),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                event.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('MMM yyyy').format(event.date)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    minHeight: 4,
                  ),
                ],
              ),
              trailing: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    WidgetRef ref,
    List<FinancialEvent> events,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final progress = event.selectedTodos.isEmpty
              ? 0.0
              : event.selectedTodos.where((t) => t.isCompleted).length /
                    event.selectedTodos.length;

          return GestureDetector(
            onTap: () => context.go('/banking/event/${event.id}'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getIconForType(event.type),
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM yyyy').format(event.date),
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[100],
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toInt()}% Done',
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForType(FinancialEventType type) {
    switch (type) {
      case FinancialEventType.buyingHouse:
        return Icons.home;
      case FinancialEventType.havingBaby:
        return Icons.child_friendly;
      case FinancialEventType.gettingMarried:
        return Icons.favorite;
      case FinancialEventType.retirement:
        return Icons.beach_access;
      case FinancialEventType.startingBusiness:
        return Icons.store;
      case FinancialEventType.university:
        return Icons.school;
      case FinancialEventType.startingSchool:
        return Icons.backpack;
      case FinancialEventType.christmas:
        return Icons.severe_cold;
      case FinancialEventType.anniversary:
        return Icons.favorite;
      case FinancialEventType.birthday:
        return Icons.cake;
      case FinancialEventType.buyingCar:
        return Icons.directions_car;
      case FinancialEventType.newJob:
        return Icons.work;
      case FinancialEventType.divorce:
        return Icons.broken_image;
      case FinancialEventType.bereavement:
        return Icons.spa;
      case FinancialEventType.gettingFit:
        return Icons.fitness_center;
    }
  }
}

class _BankProductsSection extends ConsumerWidget {
  const _BankProductsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(ownedProductsProvider);
    final viewMode = ref.watch(productsViewModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Accounts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  // View mode toggle
                  IconButton(
                    icon: Icon(
                      viewMode == ViewMode.list
                          ? Icons.grid_view
                          : Icons.view_list,
                      size: 20,
                    ),
                    onPressed: () {
                      ref.read(productsViewModeProvider.notifier).toggle();
                    },
                    tooltip: viewMode == ViewMode.list
                        ? 'Switch to grid'
                        : 'Switch to list',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => context.push('/banking/bank-products'),
                  ),
                ],
              ),
            ],
          ),
        ),
        productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => context.push('/banking/bank-products'),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 32, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Browse Accounts',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (viewMode == ViewMode.list) {
              return _buildListView(context, ref, products);
            } else {
              return _buildGridView(context, ref, products);
            }
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text('Error: $err')),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    List<OwnedProduct> products,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: products.map((product) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => context.push('/banking/my-products/${product.id}'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  _getIconForType(product.type),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: product.balance != null
                  ? Text(NumberFormat.simpleCurrency().format(product.balance))
                  : Text(product.type.replaceAll('_', ' ').toUpperCase()),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    WidgetRef ref,
    List<OwnedProduct> products,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () => context.push('/banking/my-products/${product.id}'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getIconForType(product.type),
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (product.balance != null)
                    Text(
                      NumberFormat.simpleCurrency().format(product.balance),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  else
                    Text(
                      product.type.replaceAll('_', ' '),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'loan':
        return Icons.monetization_on;
      case 'credit_card':
        return Icons.credit_card;
      case 'savings':
        return Icons.account_balance_wallet;
      case 'mortgage':
        return Icons.home;
      case 'current_account':
        return Icons.account_balance;
      case 'insurance':
        return Icons.security;
      default:
        return Icons.account_balance;
    }
  }
}
