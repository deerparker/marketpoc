import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../financial_events/models/financial_event.dart';

class FinancialGoalCard extends StatelessWidget {
  final FinancialEvent event;
  final VoidCallback? onTap;

  const FinancialGoalCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    final progress = event.selectedTodos.isEmpty
        ? 0.0
        : event.selectedTodos.where((t) => t.isCompleted).length /
              event.selectedTodos.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height removed to allow flexibility
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
          children: [
            Row(
              children: [
                Icon(
                  _getIconForType(event.type),
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              DateFormat('MMM yyyy').format(event.date),
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[100],
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% Done',
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(FinancialEventType type) {
    switch (type) {
      case FinancialEventType.buyingHouse:
        return Icons.home;
      case FinancialEventType.havingBaby:
        return Icons.child_friendly;
      case FinancialEventType.gettingMarried:
        return Icons.favorite;
      case FinancialEventType.retirement:
        return Icons.beach_access;
      case FinancialEventType.startingBusiness:
        return Icons.store;
      case FinancialEventType.university:
        return Icons.school;
      case FinancialEventType.startingSchool:
        return Icons.backpack;
      case FinancialEventType.christmas:
        return Icons.severe_cold;
      case FinancialEventType.anniversary:
        return Icons.favorite;
      case FinancialEventType.birthday:
        return Icons.cake;
      case FinancialEventType.buyingCar:
        return Icons.directions_car;
      case FinancialEventType.newJob:
        return Icons.work;
      case FinancialEventType.divorce:
        return Icons.broken_image;
      case FinancialEventType.bereavement:
        return Icons.spa;
      case FinancialEventType.gettingFit:
        return Icons.fitness_center;
    }
  }
}
