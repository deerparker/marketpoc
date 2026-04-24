import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';

class LineItem {
  final String id;
  final String title;
  final int quantity;
  final int unitPrice;
  final String? thumbnail;
  final String? variantId;

  LineItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.thumbnail,
    this.variantId,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      thumbnail: json['thumbnail'],
      variantId: json['variant_id'],
    );
  }
}

class Cart {
  final String id;
  final String currencyCode;
  final int total;
  final int subtotal;
  final List<LineItem> items;

  Cart({
    required this.id,
    required this.currencyCode,
    required this.total,
    required this.subtotal,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = <LineItem>[];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((i) => LineItem.fromJson(i))
          .toList();
    }
    return Cart(
      id: json['id'],
      currencyCode: json['currency_code'] ?? 'usd',
      total: json['total'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      items: itemsList,
    );
  }
}

class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;

  CartState({this.cart, this.isLoading = false, this.error});

  CartState copyWith({Cart? cart, bool? isLoading, String? error}) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState();
  }

  Future<void> initializeCart() async {
    // Ideally check local storage for existing cart ID
    // For now, always create a new one or keep existing in memory
    if (state.cart == null) {
      await createCart();
    }
  }

  Future<void> createCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/store/carts'),
        headers: {'x-publishable-api-key': AppConstants.publishableApiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cart = Cart.fromJson(data['cart']);
        state = state.copyWith(cart: cart, isLoading: false);
      } else {
        throw Exception(
          'Failed to create cart: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error creating cart: $e');
    }
  }

  Future<void> addToCart(String variantId, int quantity) async {
    if (state.cart == null) {
      await createCart();
      if (state.cart == null) return; // Failed to create
    }

    state = state.copyWith(isLoading: true);
    try {
      final url =
          '${AppConstants.apiBaseUrl}/store/carts/${state.cart!.id}/line-items';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-publishable-api-key': AppConstants.publishableApiKey,
        },
        body: json.encode({'variant_id': variantId, 'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        // Response contains "cart" object with updated items
        final data = json.decode(response.body);
        final cart = Cart.fromJson(data['cart']);
        state = state.copyWith(cart: cart, isLoading: false);
        debugPrint('Added to cart successfully. Items: ${cart.items.length}');
      } else {
        throw Exception(
          'Failed to add to cart: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error adding to cart: $e');
    }
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
