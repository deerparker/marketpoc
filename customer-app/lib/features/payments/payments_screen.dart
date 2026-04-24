import 'package:flutter/material.dart';
import '../home/widgets/profile_icon_button.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: const [ProfileIconButton(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(context, Icons.person, 'Pay\nContact'),
                  _buildQuickAction(context, Icons.receipt_long, 'Pay\nBill'),
                  _buildQuickAction(
                    context,
                    Icons.request_quote,
                    'Request\nMoney',
                  ),
                  _buildQuickAction(
                    context,
                    Icons.qr_code_scanner,
                    'Scan\nCode',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Recent Recipients Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Recent Recipients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors
                              .primaries[index % Colors.primaries.length]
                              .shade100,
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              color: Colors
                                  .primaries[index % Colors.primaries.length]
                                  .shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User ${index + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Activity Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                final isDebit = index % 3 != 0;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(
                      isDebit ? Icons.shopping_bag : Icons.attach_money,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  title: Text(
                    isDebit ? 'Merchant ${index + 1}' : 'Transfer from Alice',
                  ),
                  subtitle: Text(
                    DateFormat.MMMd().format(
                      DateTime.now().subtract(Duration(days: index)),
                    ),
                  ),
                  trailing: Text(
                    '${isDebit ? "-" : "+"}\$${((index + 1) * 12.50).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDebit ? Colors.black : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
