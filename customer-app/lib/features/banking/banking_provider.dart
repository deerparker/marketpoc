import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/service_locator.dart';
import '../auth/providers/auth_provider.dart';
import 'bank_products/providers/owned_products_provider.dart';

class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isDebit;

  Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isDebit,
  });
}

class Account {
  final String id;
  final String name;
  final double balance;
  final String accountNumber;
  final String? type; // 'checking', 'savings', 'credit'

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.accountNumber,
    this.type,
  });
}

final accountProvider = StreamProvider<Account?>((ref) {
  // Use real database products instead of BankService
  return ref.watch(ownedProductsProvider.stream).map((products) {
    if (products.isEmpty) {
      return null; // Return null instead of throwing exception
    }
    // Return the first checking or savings account as primary
    final primary = products.firstWhere(
      (p) => p.type == 'checking' || p.type == 'savings',
      orElse: () => products.first,
    );

    return Account(
      id: primary.id.toString(),
      name: primary.name,
      balance: primary.balance ?? 0.0,
      accountNumber: '**** ${primary.id.toString().padLeft(4, '0')}',
      type: primary.type,
    );
  });
});

final accountsProvider = StreamProvider<List<Account>>((ref) {
  // Use real database products
  return ref.watch(ownedProductsProvider.stream).map((products) {
    return products
        .map(
          (p) => Account(
            id: p.id.toString(),
            name: p.name,
            balance: p.balance ?? p.amount ?? 0.0,
            accountNumber: '**** ${p.id.toString().padLeft(4, '0')}',
            type: p.type,
          ),
        )
        .toList();
  });
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  // Still using stub service for transactions (not in database yet)
  final service = ref.watch(bankServiceProvider);
  final user = ref.watch(authProvider);
  if (user == null) throw Exception('No user logged in');
  return service.getTransactions(user.id);
});
