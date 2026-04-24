import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../banking/banking_provider.dart';

class BankProductCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;

  const BankProductCard({super.key, required this.account, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxHeight < 110;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: Theme.of(context).primaryColor,
                      size: isSmall ? 18 : 20,
                    ),
                    const Spacer(),
                    if (onTap != null && !isSmall)
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                  ],
                ),
                if (isSmall) const SizedBox(height: 8) else const Spacer(),
                Text(
                  account.name,
                  maxLines: 1, // Limit to 1 line on small cards
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 12 : 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberFormat.simpleCurrency().format(account.balance),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 12 : 14, // Reduced to 12
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
