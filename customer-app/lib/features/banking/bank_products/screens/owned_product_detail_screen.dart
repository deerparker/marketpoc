import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../providers/owned_products_provider.dart';

class OwnedProductDetailScreen extends ConsumerStatefulWidget {
  final int productId;

  const OwnedProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<OwnedProductDetailScreen> createState() =>
      _OwnedProductDetailScreenState();
}

class _OwnedProductDetailScreenState
    extends ConsumerState<OwnedProductDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _balanceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(ownedProductsProvider);

    return productsAsync.when(
      data: (products) {
        final product = products.firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => OwnedProduct(
            id: -1,
            name: 'Not Found',
            type: 'unknown',
            startDate: DateTime.now(),
          ),
        );

        if (product.id == -1) {
          return Scaffold(
            appBar: AppBar(title: const Text('Account Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Could not find this account.'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/banking'),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        // Initialize controllers with product data
        if (!_isEditing) {
          _nameController.text = product.name;
          _balanceController.text = product.balance?.toString() ?? '';
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit Account' : product.name),
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() => _isEditing = true),
                  tooltip: 'Edit',
                ),
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(product),
                  tooltip: 'Delete',
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _isEditing
                ? _buildEditForm(context, product)
                : _buildDetailView(context, product),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading account: $err')),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, OwnedProduct product) {
    final currencyFormat = NumberFormat.simpleCurrency();
    final dateFormat = DateFormat.yMMMd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        _getIconForType(product.type),
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            product.type.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Balance Section
        if (product.balance != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Current Balance'),
              trailing: Text(
                currencyFormat.format(product.balance),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),

        // Amount Section (for loans)
        if (product.amount != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Original Amount'),
              trailing: Text(
                currencyFormat.format(product.amount),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),

        // Interest Rate
        if (product.interestRate != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Interest Rate'),
              trailing: Text(
                '${product.interestRate}% APR',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),

        // Start Date
        Card(
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Opened On'),
            trailing: Text(
              dateFormat.format(product.startDate),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm(BuildContext context, OwnedProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Account Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _balanceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Balance',
            border: OutlineInputBorder(),
            prefixText: '\$ ',
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _isEditing = false),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _saveChanges(product),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveChanges(OwnedProduct product) async {
    final db = ref.read(appDatabaseProvider);
    final newBalance = double.tryParse(_balanceController.text);

    await db.updateOwnedProduct(
      product.id,
      name: _nameController.text,
      balance: newBalance,
    );

    if (mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account updated')));
    }
  }

  Future<void> _showDeleteConfirmation(OwnedProduct product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Are you sure you want to remove "${product.name}" from your accounts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(ownedProductsNotifierProvider.notifier)
          .removeProduct(product.id);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${product.name} removed')));
      context.go('/banking');
    }
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
