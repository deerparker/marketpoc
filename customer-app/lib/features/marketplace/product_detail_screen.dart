import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'models/fulfillment_journey.dart';
import 'package:url_launcher/url_launcher.dart';
import '../marketplace/marketplace_provider.dart';
import 'cart/cart_provider.dart';
import 'widgets/cart_badge_widget.dart';
import 'widgets/rating_stars_widget.dart';
import '../../core/constants.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.simpleCurrency(
      name: product.currencyCode,
    );
    final cartState = ref.watch(cartProvider);
    final sellerId = product.seller?.id;
    final fulfillmentJourneyAsync = sellerId != null
        ? ref.watch(fulfillmentJourneyProvider(sellerId))
        : const AsyncValue.data(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [const CartBadgeWidget()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: product.thumbnail != null
                  ? (product.thumbnail!.startsWith('assets/')
                        ? Image.asset(
                            product.thumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey[200]),
                          )
                        : CachedNetworkImage(
                            imageUrl: AppConstants.sanitizeImageUrl(
                              product.thumbnail!,
                            ),
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ))
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormat.format(
                              (product.price / 100) * 1.2,
                            ), // Simulated Retail
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                            currencyFormat.format(product.price / 100),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Marketbank Price',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (product.rating > 0)
                    RatingStarsWidget(
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                      starSize: 18,
                    ),
                  const SizedBox(height: 12),
                  // Seller Info (clickable)
                  if (product.seller != null)
                    InkWell(
                      onTap: () {
                        context.push(
                          '/marketplace/seller/${product.seller!.id}',
                          extra: product.seller,
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
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
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.store,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                  )
                                : const Icon(
                                    Icons.store,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sold by: ${product.seller!.name ?? 'Mercur Seller'}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              if (product.seller!.rating > 0)
                                RatingStarsWidget(
                                  rating: product.seller!.rating,
                                  reviewCount: product.seller!.reviewCount,
                                  starSize: 12,
                                  showReviewCount: false,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isEmpty
                        ? 'No description available'
                        : product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Builder(
                      builder: (context) {
                        // Check for product-level override
                        final override =
                            product.metadata['fulfillment_journey'];
                        if (override != null) {
                          return _buildFulfillmentButton(
                            context,
                            ref,
                            cartState,
                            FulfillmentJourney(
                              id: 'override',
                              type: override['type'],
                              config: override['config'],
                              sellerId: sellerId ?? '',
                            ),
                            product,
                          );
                        }

                        return fulfillmentJourneyAsync.when(
                          data: (journey) {
                            return _buildFulfillmentButton(
                              context,
                              ref,
                              cartState,
                              journey,
                              product,
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) =>
                              const Text('Error loading options'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFulfillmentButton(
    BuildContext context,
    WidgetRef ref,
    dynamic cartState, // CartState type is inferred or dynamic
    FulfillmentJourney? journey,
    Product product,
  ) {
    String buttonText = 'Add to Basket';
    VoidCallback? onPressed;

    if (journey == null || journey.type == 'manual') {
      buttonText = 'Add to Basket';
      onPressed = cartState.isLoading
          ? null
          : () async {
              if (product.variants.isNotEmpty) {
                await ref
                    .read(cartProvider.notifier)
                    .addToCart(product.variants.first.id, 1);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to basket!')),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No variants available')),
                  );
                }
              }
            };
    } else if (journey.type == 'shopify') {
      buttonText = 'Buy on Shop';
      onPressed = () async {
        final url = journey.config?['shop_url'];
        if (url != null) {
          final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      };
    } else if (journey.type == 'whatsapp') {
      buttonText = 'Chat on WhatsApp';
      onPressed = () async {
        final phone = journey.config?['phone'];
        if (phone != null) {
          final text =
              journey.config?['message_template']?.replaceAll(
                '{product}',
                product.title,
              ) ??
              'Hi';

          // Show privacy warning dialog
          final shouldProceed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text('Privacy Notice'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'When you contact this seller via WhatsApp, we will share the following information in line with your privacy settings:',
                    style: TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Product: ${product.title}'),
                        const Text('• Your phone number (via WhatsApp)'),
                        const Text('• Your enquiry message'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please NEVER disclose any details of your bank accounts, usernames or passwords to sellers.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                  ),
                  child: const Text('Proceed to WhatsApp'),
                ),
              ],
            ),
          );

          if (shouldProceed == true) {
            final uri = Uri.parse(
              'https://wa.me/$phone?text=${Uri.encodeComponent(text)}',
            );
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }
        }
      };
      // Use specific style for WhatsApp
      return FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF25D366), // WhatsApp Green
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.chat), // Use generic chat icon as fallback
        label: Text(buttonText),
      );
    } else if (journey.type == 'voucher') {
      buttonText = 'Get Voucher';
      onPressed = () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Voucher Code'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Use this code at checkout:'),
                const SizedBox(height: 10),
                SelectableText(
                  journey.config?['code'] ?? 'CODE123',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      };
    } else if (journey.type == 'link') {
      buttonText = journey.config?['button_text'] ?? 'Buy Now';
      onPressed = () async {
        final url = journey.config?['url'];

        if (url != null) {
          final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      };
    } else {
      buttonText = 'Contact Seller';
      onPressed = () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact seller for details')),
        );
      };
    }

    return FilledButton(
      onPressed: onPressed,
      child:
          cartState.isLoading && (journey == null || journey.type == 'manual')
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Text(buttonText),
    );
  }
}
