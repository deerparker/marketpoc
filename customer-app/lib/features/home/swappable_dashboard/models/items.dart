import 'dart:ui';

enum SlotSize { large, medium, small }

enum DashboardWidgetType {
  none, // For empty or generic slots if needed
  accountBalance,
  recentTransactions,
  lifeEvents,
  services,
}

class SlotConfig {
  final double width;
  final double height;
  const SlotConfig(this.width, this.height);
}

class ItemData {
  final String id;
  final SlotSize size;
  final Color color;
  final String label;
  final DashboardWidgetType? type;
  final Map<String, dynamic> config;
  final VoidCallback? onTap; // Optional tap handler for loose coupling

  ItemData({
    required this.id,
    required this.size,
    required this.color,
    required this.label,
    this.type,
    this.config = const {},
    this.onTap, // Optional tap callback
  });

  // Serialization helpers
  Map<String, dynamic> toJson() => {
    'id': id,
    'size': size.toString(),
    'color': color.value,
    'label': label,
    'type': type.toString(),
    'config': config,
  };

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      size: SlotSize.values.firstWhere(
        (s) => s.toString() == json['size'],
        orElse: () => SlotSize.small,
      ),
      color: Color(json['color']),
      label: json['label'],
      type: DashboardWidgetType.values.firstWhere(
        (t) => t.toString() == json['type'],
        orElse: () => DashboardWidgetType.none,
      ),
      config: Map<String, dynamic>.from(json['config'] ?? {}),
    );
  }
}

class SlotData {
  final String id;
  final SlotSize size;
  String? itemId; // null for empty slot
  SlotData({required this.id, required this.size, this.itemId});
}
