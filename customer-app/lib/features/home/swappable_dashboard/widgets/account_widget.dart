import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../banking/banking_provider.dart';
import '../models/items.dart';
import '../../widgets/bank_product_card.dart';
import 'dashboard_widget_container.dart';

// --- Configurable Account Widget ---
class AccountWidget extends ConsumerWidget {
  final ItemData item;
  final VoidCallback? onTap;
  const AccountWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider); // Watch all accounts
    // final viewType = item.config['viewType'] ?? 'balance'; // Unused
    final accountId = item.config['accountId']; // Get the selected account ID

    return accountsAsync.when(
      data: (accounts) {
        if (accounts.isEmpty) {
          // No accounts in database
          return DashboardWidgetContainer(
            onTap: () => context.push('/banking/bank-products'),
            title: 'No Account',
            color: item.color,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Browse Accounts',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Find the specific account by ID, or use first account as fallback
        final Account account;
        if (accountId == null ||
            accountId == 'preview' ||
            accountId == 'default') {
          // No specific account selected, use first available
          account = accounts.first;
        } else {
          account = accounts.firstWhere(
            (a) => a.id == accountId,
            orElse: () {
              return accounts.first;
            },
          );
        }

        // Use shared BankProductCard
        return BankProductCard(
          account: account,
          onTap:
              onTap ?? () => context.push('/banking/my-products/${account.id}'),
        );
      },
      loading: () => DashboardWidgetContainer(
        title: 'Loading...',
        color: item.color,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => DashboardWidgetContainer(
        title: 'Error',
        color: item.color,
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        ),
      ),
    );
  }
}
