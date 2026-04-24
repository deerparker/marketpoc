import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dashboard_controller.dart';
import 'dashboard_slot.dart';
import 'resize_dialog.dart';
import '../models/items.dart';

class DashboardRow extends ConsumerWidget {
  final String rowId;
  final List<SlotData> slots;
  final double availableWidth;
  final bool isLocked;
  final int cellsPerRow;
  final String? draggingItemId;
  final Function(String) onDragStarted;
  final VoidCallback onDragEnded;

  const DashboardRow({
    super.key,
    required this.rowId,
    required this.slots, // These are just the persistent slots
    required this.availableWidth,
    required this.isLocked,
    this.cellsPerRow = 4,
    required this.draggingItemId,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double gap = 8.0;

    // Helper to calculate cell sizes
    final smallWidth = (availableWidth - (cellsPerRow - 1) * gap) / cellsPerRow;
    final mediumWidth = smallWidth * 2 + gap;
    final largeWidth = smallWidth * 4 + gap * 3;
    final cellHeight = smallWidth * 1.3;

    // Calculate how many cells are occupied in this row
    int occupiedCells = 0;
    final validSlots = slots.where((s) => s.itemId != null).toList();
    for (final slot in validSlots) {
      occupiedCells += slot.size == SlotSize.small
          ? 1
          : slot.size == SlotSize.medium
          ? 2
          : 4;
    }

    // Calculate how many empty small slots we can add
    final emptyCells = cellsPerRow - occupiedCells;
    final emptySlots = <SlotData>[];
    for (int i = 0; i < emptyCells; i++) {
      emptySlots.add(
        SlotData(id: 'empty_${rowId}_$i', size: SlotSize.small, itemId: null),
      );
    }

    // Combine actual slots with empty fill slots
    final allSlots = [...validSlots, ...emptySlots];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16.0),
      child: SizedBox(
        width: availableWidth,
        height: cellHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < allSlots.length; i++) ...[
              if (i > 0) const SizedBox(width: gap),
              DashboardSlot(
                rowId: rowId,
                slot: allSlots[i],
                isLocked: isLocked,
                isDragging: draggingItemId != null,
                draggingItemId: draggingItemId,
                width: allSlots[i].size == SlotSize.small
                    ? smallWidth
                    : allSlots[i].size == SlotSize.medium
                    ? mediumWidth
                    : largeWidth,
                height: cellHeight,
                onResize: () => _showResizeDialog(context, ref, allSlots[i]),
                onDragStarted: onDragStarted,
                onDragEnded: onDragEnded,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showResizeDialog(BuildContext context, WidgetRef ref, SlotData slot) {
    final dashboard = ref.read(dashboardProvider);
    final rowData = dashboard.rows.firstWhere((r) => r.rowId == rowId);

    // Find the item if this slot has one
    final item = slot.itemId != null
        ? dashboard.items.firstWhere(
            (it) => it.id == slot.itemId,
            orElse: () => ItemData(
              id: 'temp',
              size: SlotSize.small,
              color: Colors.grey,
              label: 'Temp',
            ),
          )
        : null;

    // Calculate available sizes based on row space
    final List<SlotSize> availableSizes = [];

    // Count occupied cells by OTHER slots
    int occupiedCellsByOthers = 0;
    for (var s in rowData.slots) {
      if (s.itemId == null) continue; // Ignore ghost slots
      if (s.id != slot.id) {
        int sizeVal = s.size == SlotSize.small
            ? 1
            : s.size == SlotSize.medium
            ? 2
            : 4;
        occupiedCellsByOthers += sizeVal;
      }
    }

    // Check which sizes fit
    // Available space = cellsPerRow - occupiedCellsByOthers
    final remainingSpace = cellsPerRow - occupiedCellsByOthers;

    if (remainingSpace >= 1) availableSizes.add(SlotSize.small);
    if (remainingSpace >= 2) availableSizes.add(SlotSize.medium);
    if (remainingSpace >= 4) availableSizes.add(SlotSize.large);

    // Filter sizes based on item type requirements
    if (item != null) {
      switch (item.type) {
        case DashboardWidgetType.services:
          // Quick links (Services) work best as Small, but allow Medium.
          // Restrict Large as it looks broken.
          availableSizes.removeWhere((s) => s == SlotSize.large);
          break;
        case DashboardWidgetType.recentTransactions:
          // Transactions need at least Medium, prefer Large
          availableSizes.removeWhere((s) => s == SlotSize.small);
          break;
        default:
          // Accounts and Goals can be any size
          break;
      }
    }

    // Remove current size from options
    availableSizes.remove(slot.size);

    if (availableSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No other sizes available for this position'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => ResizeWidgetDialog(
        availableSizes: availableSizes,
        currentSize: slot.size,
        item: item,
        onSelected: (newSize) {
          Navigator.pop(ctx);
          final isPlaceholder = slot.id.startsWith('empty_');
          if (isPlaceholder) {
            ref
                .read(dashboardProvider.notifier)
                .cyclePlaceholderSize(rowId, slot.id, newSize);
          } else {
            ref
                .read(dashboardProvider.notifier)
                .cycleSlotSize(rowId, slot.id, targetSize: newSize);
          }
        },
      ),
    );
  }
}
