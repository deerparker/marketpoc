import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../auth/providers/auth_provider.dart';

// Provider for the Database instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final userId = ref.watch(authProvider.select((user) => user?.id));
  final dbName = userId != null ? 'db_$userId' : 'db_guest';

  final db = AppDatabase(dbName: dbName);
  // Ensure we close the database when the provider is disposed (e.g. user logs out/switches)
  ref.onDispose(db.close);

  return db;
});

// Stream provider for owned products
final ownedProductsProvider = StreamProvider<List<OwnedProduct>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchOwnedProducts();
});

// Notifier for adding/removing products
class OwnedProductsNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // No initialization needed for now, handled by methods
  }

  Future<void> addProduct({
    required String name,
    required String type,
    double? amount,
    double? balance,
    double? interestRate,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final db = ref.read(appDatabaseProvider);
      await db.addOwnedProduct(
        OwnedProductsCompanion(
          name: Value(name),
          type: Value(type),
          amount: Value(amount),
          balance: Value(balance),
          interestRate: Value(interestRate),
          startDate: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> removeProduct(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.deleteOwnedProduct(id);
  }
}

final ownedProductsNotifierProvider =
    AsyncNotifierProvider<OwnedProductsNotifier, void>(() {
      return OwnedProductsNotifier();
    });
