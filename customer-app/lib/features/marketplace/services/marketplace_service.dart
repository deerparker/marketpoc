import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../marketplace_provider.dart';
import '../models/fulfillment_journey.dart';
import 'stub_data_generator.dart';

abstract class MarketplaceService {
  Future<List<Product>> getProducts();
  Future<FulfillmentJourney?> getFulfillmentJourney(String sellerId);
}

class StubMarketplaceService implements MarketplaceService {
  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return StubDataGenerator().generateStubs(100);
  }

  @override
  Future<FulfillmentJourney?> getFulfillmentJourney(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return a dummy journey
    return null;
  }
}

class RemoteMarketplaceService implements MarketplaceService {
  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.apiBaseUrl}/store/products?fields=+seller.*,variants.*,variants.prices.*,images.*,tags.*,+metadata&limit=500',
        ),
        headers: {'x-publishable-api-key': AppConstants.publishableApiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsList = data['products'] as List;
        return productsList.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FulfillmentJourney?> getFulfillmentJourney(String sellerId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.apiBaseUrl}/store/fulfillment-journeys/$sellerId',
        ),
        headers: {'x-publishable-api-key': AppConstants.publishableApiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['journey'] != null) {
          return FulfillmentJourney.fromJson(data['journey']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
