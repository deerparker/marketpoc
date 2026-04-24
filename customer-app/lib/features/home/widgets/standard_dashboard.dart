import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../banking/banking_provider.dart';
import '../../financial_events/providers/financial_events_provider.dart';
import 'bank_product_card.dart';
import 'financial_goal_card.dart';

class StandardDashboard extends ConsumerWidget {
  const StandardDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final eventsAsync = ref.watch(financialEventsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Your Accounts'),
          const SizedBox(height: 12),
          accountsAsync.when(
            data: (accounts) {
              if (accounts.isEmpty) {
                return _buildEmptyState(
                  context,
                  'No accounts found',
                  'Browse Accounts',
                  () => context.push('/banking/bank-products'),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return SizedBox(
                    height: 100,
                    child: BankProductCard(
                      account: account,
                      onTap: () =>
                          context.push('/banking/my-products/${account.id}'),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading accounts: $err'),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Your Goals'),
          const SizedBox(height: 12),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return _buildEmptyState(
                  context,
                  'No active goals',
                  'Add a Goal',
                  () => context.push('/banking/add-event'),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return SizedBox(
                    height: 100,
                    child: FinancialGoalCard(
                      event: event,
                      onTap: () => context.push('/banking/event/${event.id}'),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading goals: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String message,
    String actionLabel,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(message, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
