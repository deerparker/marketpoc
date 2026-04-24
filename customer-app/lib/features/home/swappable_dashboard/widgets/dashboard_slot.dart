import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dashboard_controller.dart';
// import 'dashboard_widgets.dart'; // Removed to avoid duplicate exports
import '../models/items.dart';
import 'wobble_widget.dart';
import '../views/add_widget_sheet.dart';
import 'account_widget.dart';
import 'life_event_widget.dart';
import 'quick_link_widget.dart';

class DashboardSlot extends ConsumerStatefulWidget {
  final String rowId;
  final SlotData slot;
  final bool isLocked;
  final bool isDragging;
  final String? draggingItemId;
  final double width;
  final double height;
  final VoidCallback onResize;
  final Function(String) onDragStarted;
  final VoidCallback onDragEnded;

  const DashboardSlot({
    super.key,
    required this.rowId,
    required this.slot,
    required this.isLocked,
    required this.isDragging, // Unused? Or used for visual state?
    required this.draggingItemId,
    required this.width,
    required this.height,
    required this.onResize,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  ConsumerState<DashboardSlot> createState() => _DashboardSlotState();
}

class _DashboardSlotState extends ConsumerState<DashboardSlot> {
  @override
  Widget build(BuildContext context) {
    final item = widget.slot.itemId != null
        ? ref
              .read(dashboardProvider)
              .items
              .firstWhere(
                (it) => it.id == widget.slot.itemId,
                orElse: () => ItemData(
                  id: 'err',
                  size: SlotSize.small,
                  color: Colors.grey,
                  label: 'Error',
                ),
              )
        : null;

    // Item rendering logic
    Widget itemWidget = const SizedBox();
    if (item != null && item.id != 'err') {
      final onTap = item.onTap ?? () => _handleWidgetTap(item);
      itemWidget = _buildItemWidget(item, onTap: onTap);
    } else if (!widget.isLocked) {
      itemWidget = Center(child: Icon(Icons.add, color: Colors.grey[400]));
    }

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: item != null && item.id != 'err'
          ? itemWidget // The widget itself handles decoration
          : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: itemWidget,
            ),
    );

    if (widget.isLocked) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: content,
      );
    }

    // In unlocked mode: DragTarget + Draggable
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DragTarget<String>(
        onWillAccept: (_) => true,
        onAccept: (droppedItemId) {
          final dashboard = ref.read(dashboardProvider);
          final rowIndex = dashboard.rows.indexWhere(
            (r) => r.rowId == widget.rowId,
          );
          if (rowIndex == -1) return;
          final slotId = widget.slot.id;

          ref
              .read(dashboardProvider.notifier)
              .moveItem(droppedItemId, widget.rowId, slotId);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovered = candidateData.isNotEmpty;

          // Only apply wobble if THIS item is being dragged
          Widget displayWidget = content;
          if (widget.draggingItemId == item?.id) {
            displayWidget = WobbleWidget(child: content);
          }

          if (isHovered) {
            displayWidget = Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Opacity(opacity: 0.5, child: displayWidget),
            );
          } else if (item == null && !widget.isLocked) {
            // Empty slot placeholder - always tappable
            displayWidget = GestureDetector(
              onTap: () =>
                  _showAddItemDialog(context, widget.rowId, widget.slot),
              onDoubleTap: widget.onResize,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey[400],
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add Widget',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (item == null) return displayWidget;

          return LongPressDraggable<String>(
            data: item.id,
            onDragStarted: () => widget.onDragStarted(item.id),
            onDragEnd: (_) => widget.onDragEnded(),
            onDraggableCanceled: (_, __) => widget.onDragEnded(),
            feedback: Material(
              color: Colors.transparent,
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              child: Transform.scale(
                scale: 1.05,
                child: Transform.rotate(
                  angle: 0.05, // ~2.8 degrees tilt
                  child: WobbleWidget(
                    child: SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: Opacity(opacity: 0.9, child: content),
                    ),
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Interaction Wrapper for Tap/DoubleTap
                GestureDetector(
                  // Use widget.onResize callback
                  onDoubleTap: widget.onResize,
                  child: displayWidget,
                ),
                if (!widget.isLocked)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: GestureDetector(
                      onTap: () => ref
                          .read(dashboardProvider.notifier)
                          .removeItem(item.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemWidget(ItemData item, {VoidCallback? onTap}) {
    switch (item.type) {
      case DashboardWidgetType.accountBalance:
      case DashboardWidgetType.recentTransactions:
        // Pass null so the widget uses its internal navigation logic
        return AccountWidget(item: item, onTap: null);
      case DashboardWidgetType.lifeEvents:
        // Pass null so the widget uses its internal navigation logic
        return LifeEventWidget(item: item, onTap: null);
      case DashboardWidgetType.services:
        return QuickLinkWidget(item: item, onTap: onTap);
      default:
        return Container(
          color: item.color,
          alignment: Alignment.center,
          child: Text(
            item.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  void _handleWidgetTap(ItemData item) {
    if (widget.isLocked) {
      // Only handle taps when locked? Or both?
      // Original code handled taps always, unless overridden?
      // Original: if (item != null && item.id != 'err') { final onTap = item.onTap ?? () => _handleWidgetTap(item); ... }
    }

    // Copy _handleWidgetTap logic
    switch (item.type) {
      case DashboardWidgetType.accountBalance:
      case DashboardWidgetType.recentTransactions:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account detail screen coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;

      case DashboardWidgetType.lifeEvents:
        final eventId = item.config['eventId'];
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Life Event'),
            content: Text('Event ID: $eventId\n\nDetail screen coming soon.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;

      case DashboardWidgetType.services:
        final serviceType = item.config['serviceType'];
        if (serviceType == 'freeze') return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Quick Link'),
            content: const Text('This quick link is not active yet.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;

      default:
        break;
    }
  }

  void _showAddItemDialog(BuildContext context, String rowId, SlotData slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddWidgetSheet(
        slotSize: slot.size,
        onAdd: (type, label, color, config) {
          _addNewItem(rowId, slot, type, label, color, config);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _addNewItem(
    String rowId,
    SlotData slot,
    DashboardWidgetType type,
    String label,
    Color color,
    Map<String, dynamic> config,
  ) {
    final newItem = ItemData(
      id: UniqueKey().toString(),
      size: slot.size,
      color: color,
      label: label,
      type: type,
      config: config,
    );

    // Update state via provider
    ref.read(dashboardProvider.notifier).addItem(newItem);

    final dashboard = ref.read(dashboardProvider);
    final rowIndex = dashboard.rows.indexWhere((r) => r.rowId == rowId);
    if (rowIndex == -1) return;

    final isPlaceholder = slot.id.startsWith('empty_');

    if (isPlaceholder) {
      ref
          .read(dashboardProvider.notifier)
          .addPlaceholderToRow(rowId, slot.size, itemId: newItem.id);
    } else {
      final rows = ref.read(dashboardProvider).rows;
      final row = rows[rowIndex];
      final newSlots = [...row.slots];
      final idx = newSlots.indexWhere((s) => s.id == slot.id);
      if (idx != -1) {
        newSlots[idx] = SlotData(
          id: slot.id,
          size: slot.size,
          itemId: newItem.id,
        );
        ref.read(dashboardProvider.notifier).updateRowSlots(rowIndex, newSlots);
      }
    }
  }
}
