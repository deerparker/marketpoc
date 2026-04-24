import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/financial_event.dart';
import '../providers/financial_events_provider.dart';
import '../../marketplace/widgets/product_card_widget.dart';
import '../../auth/privacy_settings_provider.dart';

class EventDashboardScreen extends ConsumerWidget {
  final String eventId;

  const EventDashboardScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(financialEventsProvider);

    return eventsAsync.when(
      data: (events) {
        final event = events.firstWhere(
          (e) => e.id == eventId,
          orElse: () => FinancialEvent(
            id: 'error',
            title: 'Error',
            type: FinancialEventType.birthday, // Dummy default
            date: DateTime.now(),
            location: '',
            selectedTodos: [],
            guides: [],
          ),
        );

        if (event.id == 'error') {
          return Scaffold(
            appBar: AppBar(title: const Text('Event Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not find the requested event.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/banking'),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildEventDashboard(context, ref, event);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading event: $error')),
      ),
    );
  }

  Widget _buildEventDashboard(
    BuildContext context,
    WidgetRef ref,
    FinancialEvent event,
  ) {
    // Get privacy settings
    final privacySettings = ref.watch(privacySettingsProvider);
    final showFinancialProducts = privacySettings.maybeWhen(
      data: (s) => s.financialProductRecommendationsEnabled,
      orElse: () => true,
    );
    final showMarketplaceRecommendations = privacySettings.maybeWhen(
      data: (s) => s.marketplaceRecommendationsEnabled,
      orElse: () => true,
    );

    // Calculate progress
    final totalTodos = event.selectedTodos.length;
    final completedTodos = event.selectedTodos
        .where((t) => t.isCompleted)
        .length;
    final progress = totalTodos > 0 ? completedTodos / totalTodos : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Confirm delete
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Event?'),
                  content: const Text(
                    'Are you sure you want to remove this life event?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(financialEventsProvider.notifier)
                            .removeEvent(eventId);
                        Navigator.pop(context); // Close dialog
                        context.pop(); // Go back to list
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMMM dd, yyyy').format(event.date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.location.isNotEmpty
                              ? event.location
                              : 'No location set',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toInt()}% Completed',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Todos Section
            const Text(
              'To-Do List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...event.selectedTodos.map(
              (todo) => CheckboxListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: todo.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                value: todo.isCompleted,
                onChanged: (val) {
                  ref
                      .read(financialEventsProvider.notifier)
                      .toggleTodo(eventId, todo.id);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 32),

            // Guides Section
            const Text(
              'Guides & Resources',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...event.guides.map(
              (guide) => ExpansionTile(
                title: Text(
                  guide.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: const Icon(Icons.article_outlined),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(guide.content),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bank Products for You - conditional based on privacy settings
            if (showFinancialProducts) ...[
              const Text(
                'Bank Products for You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Tailored financial products for your "${event.title}"',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              _BankProductRecommendations(eventType: event.type),
              const SizedBox(height: 32),
            ],

            // Marketplace Recommendations - conditional based on privacy settings
            if (showMarketplaceRecommendations) ...[
              const Text(
                'Marketplace Recommendations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Curated specifically for your "${event.title}"',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              _MarketplaceRecommendations(event: event),
            ],
          ],
        ),
      ),
    );
  }
}

class _MarketplaceRecommendations extends ConsumerWidget {
  final FinancialEvent event;

  const _MarketplaceRecommendations({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(
      eventMarketplaceRecommendationsProvider(event),
    );

    if (recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Text('No recommendations found yet.'),
      );
    }

    return SizedBox(
      height: 240, // Trigger rebuild
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = recommendations[index];
          return SizedBox(
            width: 160,
            child: ProductCardWidget(
              product: product,
              onTap: () {
                context.push('/marketplace/detail', extra: product);
              },
            ),
          );
        },
      ),
    );
  }
}

class _BankProductRecommendations extends ConsumerWidget {
  final FinancialEventType eventType;

  const _BankProductRecommendations({required this.eventType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(eventBankProductsProvider(eventType));

    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Text('No products found for this event.'),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 180,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  context.push('/banking/bank-products/setup', extra: product);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getIconForProductType(product.type),
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          if (product.isPartner) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Partner',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      if (product.interestRate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${product.interestRate}% APR',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForProductType(String type) {
    switch (type) {
      case 'loan':
        return Icons.money;
      case 'mortgage':
        return Icons.home;
      case 'credit_card':
        return Icons.credit_card;
      case 'savings':
      case 'current_account':
        return Icons.account_balance_wallet;
      case 'insurance':
        return Icons.security;
      default:
        return Icons.account_balance;
    }
  }
}
