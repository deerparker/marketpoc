import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../marketplace_provider.dart';
import '../../../core/constants.dart';
import 'rating_stars_widget.dart';

class ProductCardWidget extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCardWidget({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.simpleCurrency(
      name: product.currencyCode,
    );

    // Fetch fulfillment journey for the seller to show hint/icon
    final sellerId = product.seller?.id;
    final fulfillmentJourneyAsync = sellerId != null
        ? ref.watch(fulfillmentJourneyProvider(sellerId))
        : const AsyncValue.data(null);

    return GestureDetector(
      onTap:
          onTap ??
          () {
            context.push('/marketplace/detail', extra: product);
          },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: product.thumbnail != null
                  ? (product.thumbnail!.startsWith('assets/')
                        ? Image.asset(
                            product.thumbnail!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image),
                                ),
                          )
                        : CachedNetworkImage(
                            imageUrl: AppConstants.sanitizeImageUrl(
                              product.thumbnail!,
                            ),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ))
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        currencyFormat.format(
                          (product.price / 100) * 1.2,
                        ), // Simulated Retail
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currencyFormat.format(product.price / 100),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Fulfillment Hint
                  fulfillmentJourneyAsync.when(
                    data: (journey) {
                      // Check override first (visual hint only, logic is in detail)
                      final override = product.metadata['fulfillment_journey'];
                      IconData icon = Icons.shopping_basket;
                      Color color = Colors.purple;

                      String type = journey?.type ?? 'manual';
                      if (override != null) {
                        type = override['type'];
                      }

                      if (type == 'whatsapp') {
                        icon = Icons.chat;
                        color = Colors.green;
                      } else if (type == 'link') {
                        icon = Icons.link; // or language/public
                        color = Colors.blue;
                      } else if (type == 'voucher') {
                        icon = Icons.confirmation_number;
                        color = Colors.orange;
                      }

                      return Row(
                        children: [
                          Icon(icon, size: 12, color: color),
                          const SizedBox(width: 4),
                          Text(
                            type == 'manual'
                                ? 'In-App'
                                : type[0].toUpperCase() + type.substring(1),
                            style: TextStyle(fontSize: 10, color: color),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(height: 12),
                    error: (err, stack) => const SizedBox(),
                  ),
                  const SizedBox(height: 4),
                  if (product.rating > 0)
                    RatingStarsWidget(
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                      starSize: 12,
                    ),
                  const SizedBox(height: 8),

                  // Seller info
                  if (product.seller != null)
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: product.seller!.photo != null
                              ? CachedNetworkImage(
                                  imageUrl: AppConstants.sanitizeImageUrl(
                                    product.seller!.photo!,
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Icon(
                                    Icons.store,
                                    size: 10,
                                    color: Colors.grey,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.store,
                                        size: 10,
                                        color: Colors.grey,
                                      ),
                                )
                              : const Icon(
                                  Icons.store,
                                  size: 10,
                                  color: Colors.grey,
                                ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.seller!.name ?? 'Mercur Seller',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    // Fallback if no seller info
                    Row(
                      children: [
                        const Icon(Icons.store, size: 10, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Mercur Store',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
