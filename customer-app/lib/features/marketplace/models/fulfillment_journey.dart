class FulfillmentJourney {
  final String id;
  final String type;
  final Map<String, dynamic>? config;
  final String sellerId;

  FulfillmentJourney({
    required this.id,
    required this.type,
    this.config,
    required this.sellerId,
  });

  factory FulfillmentJourney.fromJson(Map<String, dynamic> json) {
    return FulfillmentJourney(
      id: json['id'] as String,
      type: json['type'] as String,
      config: json['config'] as Map<String, dynamic>?,
      sellerId: json['seller_id'] as String,
    );
  }
}
