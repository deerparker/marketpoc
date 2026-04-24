import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/bank_product.dart';
import '../providers/owned_products_provider.dart';

class ProductSetupScreen extends ConsumerStatefulWidget {
  final BankProduct product;

  const ProductSetupScreen({super.key, required this.product});

  @override
  ConsumerState<ProductSetupScreen> createState() => _ProductSetupScreenState();
}

class _ProductSetupScreenState extends ConsumerState<ProductSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final amount = double.tryParse(_amountController.text);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    await ref
        .read(ownedProductsNotifierProvider.notifier)
        .addProduct(
          name: widget.product.title,
          type: widget.product.type,
          amount: amount,
          balance: _getInitialBalance(widget.product.type, amount),
          interestRate: widget.product.interestRate,
        );

    if (mounted) {
      context.go('/banking'); // Go back to home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully opened ${widget.product.title}!')),
      );
    }
  }

  double? _getInitialBalance(String type, double? amount) {
    if (type == 'loan') {
      return amount; // You owe the full amount
    } else if (type == 'savings') {
      return amount; // Initial deposit
    }
    return 0; // Credit card starts with 0 usage
  }

  String _getAmountLabel() {
    switch (widget.product.type) {
      case 'loan':
        return 'Loan Amount';
      case 'savings':
        return 'Initial Deposit';
      case 'credit_card':
        return 'Credit Limit Request';
      default:
        return 'Amount';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup ${widget.product.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customize your ${widget.product.title}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              if (widget.product.minAmount != null ||
                  widget.product.type == 'savings') ...[
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _getAmountLabel(),
                    prefixText: '\$ ',
                    border: const OutlineInputBorder(),
                    helperText: widget.product.minAmount != null
                        ? 'Min: \$${widget.product.minAmount!.toStringAsFixed(0)}'
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final val = double.tryParse(value);
                    if (val == null) return 'Invalid amount';
                    if (widget.product.minAmount != null &&
                        val < widget.product.minAmount!) {
                      return 'Minimum amount is \$${widget.product.minAmount}';
                    }
                    if (widget.product.maxAmount != null &&
                        val > widget.product.maxAmount!) {
                      return 'Maximum amount is \$${widget.product.maxAmount}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],

              if (widget.product.interestRate != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.percent, color: Colors.blue),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Interest Rate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${widget.product.interestRate}% APR'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _apply,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Confirm & Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
