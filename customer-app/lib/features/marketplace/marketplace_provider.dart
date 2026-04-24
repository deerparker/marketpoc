import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/service_locator.dart';
import 'models/fulfillment_journey.dart';

class Seller {
  final String id;
  final String? name;
  final String? photo;
  final String? description;
  final String? email;
  final String? phone;
  final String? location;
  final String? memberSince;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String? responseTime;

  Seller({
    required this.id,
    this.name,
    this.photo,
    this.description,
    this.email,
    this.phone,
    this.location,
    this.memberSince,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.responseTime,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    double rating = 0.0;
    int reviewCount = 0;
    String? description;
    String? email;
    String? phone;
    String? location;
    String? responseTime;
    bool isVerified = false;
    String? memberSince;

    // Parse direct fields
    description = json['description'] as String?;

    // Parse metadata for extended info
    if (json['metadata'] != null) {
      final metadata = json['metadata'];
      rating = (metadata['rating'] ?? 0).toDouble();
      reviewCount = (metadata['review_count'] ?? 0).toInt();
      email = metadata['email'] as String?;
      phone = metadata['phone'] as String?;
      location = metadata['location'] as String?;
      responseTime = metadata['response_time'] as String?;
      isVerified = metadata['is_verified'] == true;
    }

    // Parse created_at for member since
    if (json['created_at'] != null) {
      try {
        final createdAt = DateTime.parse(json['created_at']);
        memberSince = '${_monthName(createdAt.month)} ${createdAt.year}';
      } catch (_) {}
    }

    return Seller(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      description: description,
      email: email,
      phone: phone,
      location: location,
      memberSince: memberSince,
      rating: rating,
      reviewCount: reviewCount,
      isVerified: isVerified,
      responseTime: responseTime,
    );
  }

  static String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class ProductVariant {
  final String id;
  final String title;

  ProductVariant({required this.id, required this.title});

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(id: json['id'], title: json['title']);
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final int price; // In cents, simplified
  final String currencyCode;
  final List<ProductVariant> variants;
  final Seller? seller;
  final List<String> images;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic> metadata;

  Product({
    required this.id,
    required this.title,
    String? thumbnail,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.variants,
    this.seller,
    required this.images,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.metadata = const {},
  }) : _thumbnail = thumbnail;

  final String? _thumbnail;

  String? get thumbnail {
    if (_thumbnail != null) {
      return _thumbnail;
    }
    if (images.isNotEmpty) {
      return images.first;
    }
    return null;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    int price = 0;
    String currency = 'USD';
    List<ProductVariant> variantsList = [];

    // Attempt to parse variants
    if (json['variants'] != null) {
      final variantsJson = json['variants'] as List;
      variantsList = variantsJson
          .map((v) => ProductVariant.fromJson(v))
          .toList();

      if (variantsJson.isNotEmpty) {
        final v = variantsJson[0];
        if (v['prices'] != null && (v['prices'] as List).isNotEmpty) {
          final p = v['prices'][0];
          price = p['amount'];

          // Normalize prices that are suspiciously low (e.g. seeded as dollars instead of cents)
          // If less than 1000 ($10), multiply by 100.
          if (price > 0 && price < 1000) {
            price = price * 100;
          }

          currency = p['currency_code'];
        }
      }
    }

    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = (json['images'] as List)
          .map((i) => i['url'] as String)
          .toList();
    }

    List<String> tagsList = [];
    if (json['tags'] != null) {
      tagsList = (json['tags'] as List)
          .map((t) => t['value'] as String)
          .toList();
    }

    double rating = 0.0;
    int reviewCount = 0;
    if (json['metadata'] != null) {
      rating = (json['metadata']['rating'] ?? 0).toDouble();
      reviewCount = (json['metadata']['review_count'] ?? 0).toInt();
    }

    return Product(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      description: json['description'] ?? '',
      price: price,
      currencyCode: currency.toUpperCase(),
      variants: variantsList,
      seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
      images: imagesList,
      tags: tagsList,
      rating: rating,
      reviewCount: reviewCount,
      metadata: json['metadata'] ?? {},
    );
  }
}

final marketplaceProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(marketplaceServiceProvider);
  return service.getProducts();
});

final fulfillmentJourneyProvider =
    FutureProvider.family<FulfillmentJourney?, String>((ref, sellerId) async {
      final service = ref.watch(marketplaceServiceProvider);
      return service.getFulfillmentJourney(sellerId);
    });
