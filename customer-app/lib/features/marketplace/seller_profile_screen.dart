import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'marketplace_provider.dart';
import 'widgets/product_card_widget.dart';
import 'widgets/rating_stars_widget.dart';
import 'widgets/cart_badge_widget.dart';

class SellerProfileScreen extends ConsumerWidget {
  final String sellerId;
  final Seller? sellerExtra;

  const SellerProfileScreen({
    super.key,
    required this.sellerId,
    this.sellerExtra,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We might want a specific provider to fetch seller by ID if details are missing,
    // but for now we'll rely on the extra or filtering the products list.
    // Ideally, we'd have a 'sellerProvider(id)'.

    final productsAsync = ref.watch(marketplaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(sellerExtra?.name ?? 'Seller Profile'),
        actions: const [CartBadgeWidget()],
      ),
      body: productsAsync.when(
        data: (products) {
          final sellerProducts = products
              .where((p) => p.seller?.id == sellerId)
              .toList();
          final seller = sellerExtra ?? sellerProducts.firstOrNull?.seller;

          if (seller == null) {
            return const Center(child: Text('Seller not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: seller.photo != null
                            ? NetworkImage(seller.photo!)
                            : null,
                        child: seller.photo == null
                            ? const Icon(Icons.store, size: 40)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        seller.name ?? 'Unknown Store',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      RatingStarsWidget(
                        rating: seller.rating,
                        reviewCount: seller.reviewCount,
                        starSize: 20,
                      ),
                      const SizedBox(height: 16),
                      // Mock Contact Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'contact@${seller.name?.replaceAll(' ', '').toLowerCase() ?? 'seller'}.com',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Icon(Icons.phone_outlined, size: 20),
                                SizedBox(width: 8),
                                Text('+1 (555) 123-4567'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.60,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = sellerProducts[index];
                    return ProductCardWidget(
                      product: product,
                      onTap: () {
                        context.push('/marketplace/detail', extra: product);
                      },
                    );
                  }, childCount: sellerProducts.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
