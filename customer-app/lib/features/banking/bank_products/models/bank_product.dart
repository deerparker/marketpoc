class BankProduct {
  final String id;
  final String title;
  final String description;
  final String type; // 'loan', 'credit_card', 'savings'
  final String imageUrl;
  final double? interestRate;

  // For UI display, maybe add min/max amounts?
  final double? minAmount;
  final double? maxAmount;

  final String? partnerName;
  final bool isPartner;

  const BankProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.imageUrl,
    this.interestRate,
    this.minAmount,
    this.maxAmount,
    this.partnerName,
    this.isPartner = false,
  });
}
