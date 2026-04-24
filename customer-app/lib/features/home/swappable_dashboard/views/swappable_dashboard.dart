import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_row.dart';

class DashboardArea extends ConsumerStatefulWidget {
  const DashboardArea({super.key});

  @override
  ConsumerState<DashboardArea> createState() => _DashboardAreaState();
}

class _DashboardAreaState extends ConsumerState<DashboardArea> {
  String? _draggingItemId; // Track which item is currently being dragged

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final rows = dashboardState.rows;
    final isLocked = dashboardState.isLocked;

    const double outerPadding = 32.0;
    final availableWidth = MediaQuery.of(context).size.width - outerPadding;

    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_customize, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Dashboard is empty.',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            if (!isLocked)
              TextButton.icon(
                onPressed: () => ref.read(dashboardProvider.notifier).addRow(),
                icon: const Icon(Icons.add),
                label: const Text('Add Row'),
              ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int rowIndex = 0; rowIndex < rows.length; rowIndex++)
          isLocked
              ? DashboardRow(
                  rowId: rows[rowIndex].rowId,
                  slots: rows[rowIndex].slots,
                  availableWidth: availableWidth,
                  isLocked: isLocked,
                  draggingItemId: _draggingItemId,
                  onDragStarted: (id) => setState(() => _draggingItemId = id),
                  onDragEnded: () => setState(() => _draggingItemId = null),
                )
              : Dismissible(
                  key: ValueKey(rows[rowIndex].rowId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: Colors.red[300],
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (_) {
                    ref.read(dashboardProvider.notifier).removeRow(rowIndex);
                  },
                  child: DashboardRow(
                    rowId: rows[rowIndex].rowId,
                    slots: rows[rowIndex].slots,
                    availableWidth: availableWidth,
                    isLocked: isLocked,
                    draggingItemId: _draggingItemId,
                    onDragStarted: (id) => setState(() => _draggingItemId = id),
                    onDragEnded: () => setState(() => _draggingItemId = null),
                  ),
                ),

        if (!isLocked)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: OutlinedButton.icon(
              onPressed: () => ref.read(dashboardProvider.notifier).addRow(),
              icon: const Icon(Icons.add),
              label: const Text('Add Row'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                foregroundColor: Colors.grey[700],
              ),
            ),
          ),
      ],
    );
  }
}
