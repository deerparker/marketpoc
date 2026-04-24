import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/providers/auth_provider.dart';
import '../models/items.dart';

// State model for the dashboard
class DashboardState {
  final List<ItemData> items;
  final List<RowData> rows;
  final bool isLocked;

  DashboardState({
    required this.items,
    required this.rows,
    this.isLocked = true,
  });

  DashboardState copyWith({
    List<ItemData>? items,
    List<RowData>? rows,
    bool? isLocked,
  }) {
    return DashboardState(
      items: items ?? this.items,
      rows: rows ?? this.rows,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class RowData {
  final String rowId;
  final List<SlotData> slots;

  RowData({required this.rowId, required this.slots});
}

// ... (DashboardState and RowData unchanged)

class DashboardController extends StateNotifier<DashboardState> {
  final String? userId;

  DashboardController({this.userId})
    : super(DashboardState(items: [], rows: [])) {
    _loadConfig();
  }

  String get _prefsKey => 'swappable_dashboard_config_v2_${userId ?? "guest"}';

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    // ... rest of method unchanged

    if (jsonStr != null) {
      try {
        final config = jsonDecode(jsonStr);
        final loadedItems = (config['items'] as List)
            .map((e) => ItemData.fromJson(e))
            .toList();

        final loadedRows = (config['rows'] as List)
            .map(
              (r) => RowData(
                rowId: r['rowId'],
                slots: (r['slots'] as List)
                    .map(
                      (s) => SlotData(
                        id: s['id'],
                        size: SlotSize.values.firstWhere(
                          (sz) => sz.toString() == s['size'],
                        ),
                        itemId: s['itemId'],
                      ),
                    )
                    // Purge empty slots on load (basic check)
                    .where((s) => s.itemId != null)
                    .toList(),
              ),
            )
            .toList();

        state = state.copyWith(items: loadedItems, rows: loadedRows);
        _validateState(); // Thorough cleanup of dead references
        return; // Early return if successful
      } catch (e) {
        debugPrint('Error loading dashboard config: $e');
      }
    }

    // Fallback / Initial State
    _initializeDefaultState();
  }

  void _validateState() {
    // 1. Remove slots that point to non-existent items
    // 2. Remove items that are not in any slot (optional, but keeps clean)
    final validItemIds = state.items.map((i) => i.id).toSet();

    final cleanedRows = state.rows.map((row) {
      final validSlots = row.slots.where((slot) {
        if (slot.itemId == null) return false; // Remove persistence ghosts
        return validItemIds.contains(slot.itemId); // Remove dead links
      }).toList();
      return RowData(rowId: row.rowId, slots: validSlots);
    }).toList();

    // 3. Ensure we didn't empty out rows completely?
    // Actually empty rows are fine, but let's keep rows cleaner.

    if (cleanedRows.length != state.rows.length ||
        cleanedRows.any(
          (r) =>
              r.slots.length !=
              state.rows.firstWhere((old) => old.rowId == r.rowId).slots.length,
        )) {
      debugPrint(
        'DashboardController: Fix/Validated state by removing dead slots/ghosts.',
      );
      state = state.copyWith(rows: cleanedRows);
      _saveConfig();
    }
  }

  void _initializeDefaultState() {
    // Default setup:
    // Row 1: Account Balance (Medium) + Life Events (Medium)
    // Row 2: Recent Transactions (Large)

    final items = [
      ItemData(
        id: 'balance_1',
        size: SlotSize.medium,
        color: Colors.blueAccent,
        label: 'Balance',
        type: DashboardWidgetType.accountBalance,
        config: {'viewType': 'balance', 'accountId': 'default'},
      ),
      ItemData(
        id: 'events_1',
        size: SlotSize.medium,
        color: Colors.orangeAccent,
        label: 'Life Events',
        type: DashboardWidgetType.lifeEvents,
        config: {'eventId': 'trip_paris'},
      ),
      ItemData(
        id: 'transactions_1',
        size: SlotSize.large,
        color: Colors.green,
        label: 'Transactions',
        type: DashboardWidgetType.recentTransactions,
        config: {'viewType': 'transactions', 'accountId': 'default'},
      ),
      ItemData(
        id: 'services_1',
        size: SlotSize.small,
        color: Colors.purpleAccent,
        label: 'Services',
        type: DashboardWidgetType.services,
        config: {'serviceType': 'chat'},
      ),
    ];

    final rows = [
      RowData(
        rowId: UniqueKey().toString(),
        slots: [
          SlotData(
            id: UniqueKey().toString(),
            size: SlotSize.medium,
            itemId: 'balance_1',
          ),
          SlotData(
            id: UniqueKey().toString(),
            size: SlotSize.medium,
            itemId: 'events_1',
          ),
        ],
      ),
      RowData(
        rowId: UniqueKey().toString(),
        slots: [
          SlotData(
            id: UniqueKey().toString(),
            size: SlotSize.large,
            itemId: 'transactions_1',
          ),
        ],
      ),
      RowData(
        rowId: UniqueKey().toString(),
        slots: [
          SlotData(
            id: UniqueKey().toString(),
            size: SlotSize.small,
            itemId: 'services_1',
          ),
          SlotData(id: UniqueKey().toString(), size: SlotSize.small),
          SlotData(id: UniqueKey().toString(), size: SlotSize.small),
          SlotData(id: UniqueKey().toString(), size: SlotSize.small),
        ],
      ),
    ];

    state = state.copyWith(items: items, rows: rows);
    _saveConfig();
  }

  Future<void> _saveConfig() async {
    _cleanupEmptyRows();
    final prefs = await SharedPreferences.getInstance();
    final config = {
      'items': state.items.map((e) => e.toJson()).toList(),
      'rows': state.rows
          .map(
            (r) => {
              'rowId': r.rowId,
              'slots': r.slots
                  .map(
                    (s) => {
                      'id': s.id,
                      'size': s.size.toString(),
                      'itemId': s.itemId,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
    };
    await prefs.setString(_prefsKey, jsonEncode(config));
  }

  void _cleanupEmptyRows() {
    // Only cleanup if the dashboard is locked
    if (!state.isLocked) return;

    // Keep rows that have at least one slot with an itemId
    final cleanedRows = state.rows.where((row) {
      return row.slots.any((slot) => slot.itemId != null);
    }).toList();

    if (cleanedRows.length != state.rows.length) {
      state = state.copyWith(rows: cleanedRows);
    }
  }

  void toggleLock() {
    state = state.copyWith(isLocked: !state.isLocked);
    if (state.isLocked) {
      _saveConfig();
    }
  }

  void addRow() {
    final newRow = RowData(
      rowId: UniqueKey().toString(),
      slots: [
        SlotData(id: UniqueKey().toString(), size: SlotSize.medium),
        SlotData(id: UniqueKey().toString(), size: SlotSize.medium),
      ],
    );
    state = state.copyWith(rows: [...state.rows, newRow]);
    _saveConfig();
  }

  void removeRow(int index) {
    if (index < 0 || index >= state.rows.length) return;

    final row = state.rows[index];
    // Cleanup items in this row
    final rowItemIds = row.slots
        .map((s) => s.itemId)
        .whereType<String>()
        .toSet();

    final newItems = state.items
        .where((item) => !rowItemIds.contains(item.id))
        .toList();
    final newRows = [...state.rows]..removeAt(index);

    state = state.copyWith(items: newItems, rows: newRows);
    _saveConfig();
  }

  void updateRowSlots(int rowIndex, List<SlotData> newSlots) {
    final newRows = [...state.rows];
    final cleanedSlots = _ensureRowCapacity(newSlots);
    newRows[rowIndex] = RowData(
      rowId: newRows[rowIndex].rowId,
      slots: cleanedSlots,
    );
    state = state.copyWith(rows: newRows);
    _saveConfig();
  }

  void updateItems(List<ItemData> newItems) {
    state = state.copyWith(items: newItems);
    _saveConfig();
  }

  void addItem(ItemData item) {
    state = state.copyWith(items: [...state.items, item]);
    _saveConfig();
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != itemId).toList(),
    );
    // Also clear from slots
    final newRows = state.rows.map((r) {
      return RowData(
        rowId: r.rowId,
        slots: r.slots.where((s) => s.itemId != itemId).toList(),
      );
    }).toList();
    state = state.copyWith(rows: newRows);
    _saveConfig();
  }

  void moveItem(String itemId, String targetRowId, String targetSlotId) {
    // 1. Find source
    RowData? sourceRow;
    SlotData? sourceSlot;

    for (var r in state.rows) {
      for (var s in r.slots) {
        if (s.itemId == itemId) {
          sourceRow = r;
          sourceSlot = s;
          break;
        }
      }
      if (sourceRow != null) break;
    }

    if (sourceRow == null || sourceSlot == null) return;

    // 2. Find target
    final targetRowIndex = state.rows.indexWhere((r) => r.rowId == targetRowId);
    if (targetRowIndex == -1) return;

    final targetRow = state.rows[targetRowIndex];
    final targetSlotIndex = targetRow.slots.indexWhere(
      (s) => s.id == targetSlotId,
    );

    // Support dropping onto placeholders (not in state yet)
    final bool isTargetPlaceholder = targetSlotId.startsWith('empty_');
    if (targetSlotIndex == -1 && !isTargetPlaceholder) return;

    final SlotData targetSlot;
    if (isTargetPlaceholder) {
      targetSlot = SlotData(
        id: targetSlotId,
        size: SlotSize.small,
        itemId: null,
      );
    } else {
      targetSlot = targetRow.slots[targetSlotIndex];
    }

    // 3. Update State
    // Remove from source
    final newSourceSlots = sourceRow.slots
        .where((s) => s.id != sourceSlot!.id)
        .toList();

    // If target has item, swap it back to source? Or just overwrite?
    // For simplicity, let's swap if source and target are different.
    // If they are in same row, easy. If diff rows, need to update both rows.

    final swappedItemId = targetSlot.itemId;

    // Update Target
    final newTargetSlots = targetRow.slots.map((s) {
      if (s.id == targetSlot.id)
        return SlotData(id: s.id, size: s.size, itemId: itemId);
      return s;
    }).toList();

    List<RowData> newRows = [...state.rows];

    // Apply changes
    if (sourceRow.rowId == targetRow.rowId) {
      // Same row Move/Swap
      final rowSlots = sourceRow.slots.map((s) {
        if (s.id == sourceSlot!.id)
          return SlotData(id: s.id, size: s.size, itemId: swappedItemId);
        if (s.id == targetSlot.id)
          return SlotData(id: s.id, size: s.size, itemId: itemId);
        return s;
      }).toList();
      newRows[state.rows.indexOf(sourceRow)] = RowData(
        rowId: sourceRow.rowId,
        slots: rowSlots,
      );
    } else {
      // Diff row
      // Update Source Row (putting swapped item there)
      newRows[state.rows.indexOf(sourceRow)] = RowData(
        rowId: sourceRow.rowId,
        slots: newSourceSlots.map((s) {
          if (s.id == sourceSlot!.id)
            return SlotData(id: s.id, size: s.size, itemId: swappedItemId);
          return s;
        }).toList(),
      );

      // Update Target Row
      if (isTargetPlaceholder) {
        // Replace dynamic placeholder with a persistent slot
        newRows[targetRowIndex] = RowData(
          rowId: targetRow.rowId,
          slots: [
            ...targetRow.slots,
            SlotData(
              id: UniqueKey().toString(),
              size: SlotSize.small,
              itemId: itemId,
            ),
          ],
        );
      } else {
        newRows[targetRowIndex] = RowData(
          rowId: targetRow.rowId,
          slots: newTargetSlots,
        );
      }
    }

    state = state.copyWith(rows: newRows);
    _saveConfig();
  }

  void cycleSlotSize(String rowId, String slotId, {SlotSize? targetSize}) {
    final rowIndex = state.rows.indexWhere((r) => r.rowId == rowId);
    if (rowIndex == -1) return;

    final row = state.rows[rowIndex];
    final slotIndex = row.slots.indexWhere((s) => s.id == slotId);
    if (slotIndex == -1) return;

    final currentSlot = row.slots[slotIndex];

    SlotSize newSize;
    if (targetSize != null) {
      newSize = targetSize;
    } else {
      // Cycle through sizes
      newSize = switch (currentSlot.size) {
        SlotSize.small => SlotSize.medium,
        SlotSize.medium => SlotSize.large,
        SlotSize.large => SlotSize.small,
      };
    }

    final newSlots = [...row.slots];

    // Consolidation logic: If resizing an empty slot, clear other empty slots in this row
    // to make room for the new size and prevent auto-pruning.
    if (currentSlot.itemId == null) {
      newSlots.removeWhere((s) => s.id != slotId && s.itemId == null);
      // Re-find the index after removal
      final updatedIdx = newSlots.indexWhere((s) => s.id == slotId);
      if (updatedIdx != -1) {
        newSlots[updatedIdx] = SlotData(
          id: currentSlot.id,
          size: newSize,
          itemId: null,
        );
      }
    } else {
      newSlots[slotIndex] = SlotData(
        id: currentSlot.id,
        size: newSize,
        itemId: currentSlot.itemId,
      );
    }
    updateRowSlots(rowIndex, newSlots);
  }

  void addPlaceholderToRow(String rowId, SlotSize size, {String? itemId}) {
    final rowIndex = state.rows.indexWhere((r) => r.rowId == rowId);
    if (rowIndex == -1) return;

    final row = state.rows[rowIndex];
    final newSlots = [...row.slots];

    // Clear existing empty slots if adding a large one
    if (size == SlotSize.large) {
      newSlots.removeWhere((s) => s.itemId == null);
    }

    newSlots.add(
      SlotData(id: UniqueKey().toString(), size: size, itemId: itemId),
    );

    updateRowSlots(rowIndex, newSlots);
  }

  void cyclePlaceholderSize(
    String rowId,
    String placeholderId,
    SlotSize targetSize,
  ) {
    // This is called for dynamic placeholders (ids starting with 'empty_')
    final rowIndex = state.rows.indexWhere((r) => r.rowId == rowId);
    if (rowIndex == -1) return;

    final row = state.rows[rowIndex];
    final newSlots = [...row.slots];

    // When converting a dynamic placeholder to a persistent empty slot,
    // clear other empty slots if necessary to fit.
    if (targetSize == SlotSize.large || targetSize == SlotSize.medium) {
      newSlots.removeWhere((s) => s.itemId == null);
    }

    newSlots.add(
      SlotData(id: UniqueKey().toString(), size: targetSize, itemId: null),
    );

    updateRowSlots(rowIndex, newSlots);
  }

  /// Ensures a row does not exceed 4 cells by removing empty slots from the end.
  List<SlotData> _ensureRowCapacity(List<SlotData> slots) {
    int total = 0;
    for (var s in slots) {
      total += s.size == SlotSize.small
          ? 1
          : s.size == SlotSize.medium
          ? 2
          : 4;
    }

    if (total <= 4) return slots;

    // Remove empty slots from the end until it fits or only items remain
    final result = [...slots];
    for (int i = result.length - 1; i >= 0; i--) {
      if (result[i].itemId == null) {
        final size = result[i].size == SlotSize.small
            ? 1
            : result[i].size == SlotSize.medium
            ? 2
            : 4;
        result.removeAt(i);
        total -= size;
        if (total <= 4) break;
      }
    }
    return result;
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final user = ref.watch(authProvider);
      return DashboardController(userId: user?.id);
    });
