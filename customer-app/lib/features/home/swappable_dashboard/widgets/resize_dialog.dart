import 'package:flutter/material.dart';
import '../models/items.dart';

class ResizeWidgetDialog extends StatelessWidget {
  final List<SlotSize> availableSizes;
  final SlotSize currentSize;
  final Function(SlotSize) onSelected;
  final ItemData? item; // For color/styling

  const ResizeWidgetDialog({
    super.key,
    required this.availableSizes,
    required this.currentSize,
    required this.onSelected,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Resize Widget'),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select new size for this position:',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...availableSizes.map((size) {
                final label = _getSizeLabel(size);
                final columns = size == SlotSize.small
                    ? 1
                    : size == SlotSize.medium
                    ? 2
                    : 4;

                return InkWell(
                  onTap: () => onSelected(size),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Visual indicator of size
                        Container(
                          height: 48, // Taller preview area
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          child: Row(
                            children: List.generate(4, (i) {
                              return Expanded(
                                child: Container(
                                  height: 32,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: i < columns
                                        ? (item?.color ??
                                              Theme.of(context).primaryColor)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(6),
                                    border: i < columns
                                        ? null
                                        : Border.all(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                  ),
                                  child: i < columns && i == 0
                                      ? const Center(
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  String _getSizeLabel(SlotSize size) {
    switch (size) {
      case SlotSize.small:
        return 'Small (1 column)';
      case SlotSize.medium:
        return 'Medium (2 columns)';
      case SlotSize.large:
        return 'Large (full width)';
    }
  }
}
