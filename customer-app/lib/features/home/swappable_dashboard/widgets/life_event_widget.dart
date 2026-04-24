import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../financial_events/providers/financial_events_provider.dart';
import '../../../financial_events/models/financial_event.dart';
import '../models/items.dart';
import '../../widgets/financial_goal_card.dart';
import 'dashboard_widget_container.dart';

// --- Configurable Life Event Widget ---
class LifeEventWidget extends ConsumerWidget {
  final ItemData item;
  final VoidCallback? onTap;
  const LifeEventWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = item.config['eventId'];
    final eventsAsync = ref.watch(financialEventsProvider);

    return eventsAsync.when(
      data: (events) {
        // Find the specific event
        FinancialEvent? event;
        try {
          event = events.firstWhere((e) => e.id == eventId);
        } catch (_) {
          event = null;
        }

        // Fallback: Use first available if not found
        if (event == null && events.isNotEmpty) {
          event = events.first;
        }

        if (event == null) {
          return DashboardWidgetContainer(
            onTap: () {
              // Redirect to "Add Event" if none found
              context.push('/banking/add-event');
            },
            title: 'My Goals',
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
                      'Rate goals in Banking',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Calculate progress - Unused in this widget currently as we pass event to card
        // final progress = event.selectedTodos.isEmpty
        //     ? 0.0
        //     : event.selectedTodos.where((t) => t.isCompleted).length /
        //           event.selectedTodos.length;

        // Use the same Container design as BankingScreen > _buildGridView
        // We wrap it in our DashboardWidgetContainer to handle the "swappable" frame if needed,
        // OR we can just return the card itself.
        // DashboardWidgetContainer adds a header if we want one.
        // Let's use DashboardWidgetContainer for consistency with other swappable widgets,
        // but style the inner content to match BankingScreen cards.

        // Use a final variable for closure capture to ensure non-nullability
        final safeEvent = event;

        // Use shared FinancialGoalCard
        return FinancialGoalCard(
          event: safeEvent,
          onTap: onTap ?? () => context.push('/banking/event/${safeEvent.id}'),
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
