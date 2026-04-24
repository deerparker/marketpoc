import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../banking/banking_provider.dart';
import '../../../financial_events/providers/financial_events_provider.dart';
import '../widgets/dashboard_widgets.dart';
import '../models/items.dart';

class AddWidgetSheet extends ConsumerStatefulWidget {
  final Function(DashboardWidgetType, String, Color, Map<String, dynamic>)
  onAdd;
  final SlotSize slotSize;

  const AddWidgetSheet({
    super.key,
    required this.onAdd,
    required this.slotSize,
  });

  @override
  ConsumerState<AddWidgetSheet> createState() => _AddWidgetSheetState();
}

class _AddWidgetSheetState extends ConsumerState<AddWidgetSheet> {
  int _step = 0; // 0: Category, 1: Specific Item, 2: View Type
  String? _selectedCategory;
  Map<String, dynamic>?
  _selectedItemData; // {'id', 'name', 'type', 'accountObject'}

  // Stub data for flow
  final _categories = ['Your products', 'Your goals', 'Quick links'];

  final _serviceItems = [
    {'id': 'chat', 'name': 'Chat Support', 'type': 'service'},
    {'id': 'freeze', 'name': 'Freeze Card', 'type': 'service'},
    {'id': 'branch', 'name': 'Find Branch', 'type': 'service'},
    {'id': 'statement', 'name': 'Statements', 'type': 'service'},
    {'id': 'transfer', 'name': 'Transfer Money', 'type': 'service'},
    {'id': 'budget', 'name': 'Budget Tools', 'type': 'service'},
  ];

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _step = 1;
    });
  }

  void _onItemSelected(Map<String, dynamic> item) {
    if (_selectedCategory == 'Quick links') {
      widget.onAdd(
        DashboardWidgetType.services,
        item['name'],
        Colors.purpleAccent,
        {'serviceType': item['id']},
      );
    } else if (_selectedCategory == 'Your goals') {
      widget.onAdd(
        DashboardWidgetType.lifeEvents,
        item['name'],
        Colors.orangeAccent,
        {'eventId': item['id']},
      );
    } else {
      // Banking
      setState(() {
        _selectedItemData = item;
        _step = 2;
      });
    }
  }

  void _onViewTypeSelected(String viewType) {
    widget.onAdd(
      DashboardWidgetType.accountBalance,
      _selectedItemData!['name'],
      Colors.blueAccent,
      {'accountId': _selectedItemData!['id'], 'viewType': viewType},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Row(
            children: [
              if (_step > 0)
                IconButton(
                  onPressed: () => setState(() => _step--),
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(
                child: Text(
                  _step == 0
                      ? 'Select Category'
                      : _step == 1
                      ? 'Select Item'
                      : 'Select View',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Divider(),
          Expanded(child: _buildStepContent()),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    if (_step == 0) {
      return ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return ListTile(
            title: Text(cat),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _onCategorySelected(cat),
          );
        },
      );
    } else if (_step == 1) {
      return _buildItemList();
    } else {
      return _buildViewTypeSelection();
    }
  }

  Widget _buildItemList() {
    if (_selectedCategory == 'Your products') {
      // Fetch REAL accounts (multiple)
      final accountsAsync = ref.watch(accountsProvider);

      return accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            // Empty state - direct to Products screen
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Products Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Open an account or apply for a product to add them to your dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];

              final icon = account.type == 'checking'
                  ? Icons.account_balance
                  : account.type == 'savings'
                  ? Icons.savings
                  : Icons.credit_card;

              return ListTile(
                leading: Icon(icon),
                title: Text(account.name),
                subtitle: Text(account.accountNumber),
                trailing: Text(
                  '\$${account.balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: account.balance < 0 ? Colors.red : Colors.green,
                  ),
                ),
                onTap: () => _onItemSelected({
                  'id': account.id,
                  'name': account.name,
                  'type': account.type ?? 'checking',
                }),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      );
    }

    if (_selectedCategory == 'Your goals') {
      final eventsAsync = ref.watch(financialEventsProvider);

      return eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            // Empty state - direct to Products screen
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No Goals Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a financial goal in the Products section to track them here',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final daysUntil = event.date.difference(DateTime.now()).inDays;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.event,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(event.title),
                subtitle: Text('$daysUntil days away'),
                onTap: () => _onItemSelected({
                  'id': event.id,
                  'name': event.title,
                  'type': 'event',
                }),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      );
    }

    final items = _serviceItems;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item['name'] as String),
          subtitle: Text(item['type'] as String),
          onTap: () => _onItemSelected(item),
        );
      },
    );
  }

  Widget _buildViewTypeSelection() {
    // Filter Logic:
    // If slotSize is Small, disable "Transactions" (requires Medium/Large)
    final canShowTransactions = widget.slotSize != SlotSize.small;

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Select how you want this to look:',
            style: TextStyle(color: Colors.grey),
          ),
        ),

        InkWell(
          onTap: () => _onViewTypeSelected('balance'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Balance View',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AbsorbPointer(
                  child: SizedBox(
                    height: 100,
                    width: 180,
                    child: AccountWidget(
                      item: ItemData(
                        id: 'preview_1',
                        size: SlotSize.medium,
                        color: Colors.blueAccent,
                        label: 'Balance',
                        type: DashboardWidgetType.accountBalance,
                        config: {
                          'viewType': 'balance',
                          'accountId':
                              _selectedItemData!['id'], // Use selected account
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),

        if (!canShowTransactions)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Recent Transactions view requires a medium or large tile.',
              style: TextStyle(
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          InkWell(
            onTap: () => _onViewTypeSelected('transactions'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Activity View',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AbsorbPointer(
                    child: SizedBox(
                      height: 100,
                      width: 320,
                      child: AccountWidget(
                        item: ItemData(
                          id: 'preview_2',
                          size: SlotSize.large,
                          color: Colors.green,
                          label: 'Transactions',
                          type: DashboardWidgetType.recentTransactions,
                          config: {
                            'viewType': 'transactions',
                            'accountId':
                                _selectedItemData!['id'], // Use selected account
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
