import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import 'marketplace_provider.dart';
import 'widgets/rating_stars_widget.dart';
import 'widgets/product_card_widget.dart';
import 'widgets/cart_badge_widget.dart';

class SellerScreen extends ConsumerWidget {
  final String sellerId;
  final Seller? sellerExtra;

  const SellerScreen({super.key, required this.sellerId, this.sellerExtra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // Seller Header Section
              SliverToBoxAdapter(child: _buildSellerHeader(context, seller)),

              // Contact & Details Section
              SliverToBoxAdapter(child: _buildContactSection(context, seller)),

              // Actions Section
              SliverToBoxAdapter(child: _buildActionsSection(context, seller)),

              // Products Section Header
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    'Products from this seller',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Products Grid
              if (sellerProducts.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('No products available from this seller.'),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
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
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSellerHeader(BuildContext context, Seller seller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Seller Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: seller.photo != null
                ? CachedNetworkImage(
                    imageUrl: AppConstants.sanitizeImageUrl(seller.photo!),
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Icon(Icons.store, size: 50, color: Colors.grey),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.store, size: 50, color: Colors.grey),
                  )
                : const Icon(Icons.store, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Seller Name
          Text(
            seller.name ?? 'Unknown Seller',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Rating
          if (seller.rating > 0)
            RatingStarsWidget(
              rating: seller.rating,
              reviewCount: seller.reviewCount,
              starSize: 22,
            )
          else
            Text('No ratings yet', style: TextStyle(color: Colors.grey[600])),

          const SizedBox(height: 8),

          // Verified Badge (from API)
          if (seller.isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 4),
                  Text(
                    'Verified Seller',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, Seller seller) {
    // Generate mock contact details based on seller name
    final sellerSlug =
        seller.name?.replaceAll(' ', '').toLowerCase() ?? 'seller';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seller Details',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Description (if available)
              if (seller.description != null &&
                  seller.description!.isNotEmpty) ...[
                Text(
                  seller.description!,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const Divider(height: 24),
              ],

              // Location
              _buildDetailRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: seller.location ?? 'United Kingdom',
              ),
              const Divider(height: 24),

              // Email
              _buildDetailRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: seller.email ?? 'contact@$sellerSlug.com',
              ),
              const Divider(height: 24),

              // Phone
              _buildDetailRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: seller.phone ?? '+44 (0) 20 1234 5678',
              ),
              const Divider(height: 24),

              // Response Time
              _buildDetailRow(
                icon: Icons.schedule_outlined,
                label: 'Avg. Response Time',
                value: seller.responseTime ?? 'Within 24 hours',
              ),
              const Divider(height: 24),

              // Member Since
              _buildDetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Member Since',
                value: seller.memberSince ?? 'January 2024',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context, Seller seller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message feature coming soon')),
                );
              },
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Message'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showDisputeDialog(context, seller),
              icon: const Icon(Icons.flag_outlined),
              label: const Text('Open Dispute'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisputeDialog(BuildContext context, Seller seller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.flag, color: Colors.orange),
            SizedBox(width: 8),
            Text('Open a Dispute'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to open a dispute with ${seller.name ?? 'this seller'}.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Please select the reason for your dispute:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            _DisputeReasonSelector(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Dispute submitted. Our team will review it within 48 hours.',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Submit Dispute'),
          ),
        ],
      ),
    );
  }
}

class _DisputeReasonSelector extends StatefulWidget {
  @override
  State<_DisputeReasonSelector> createState() => _DisputeReasonSelectorState();
}

class _DisputeReasonSelectorState extends State<_DisputeReasonSelector> {
  String? _selectedReason;

  final _reasons = [
    'Item not received',
    'Item not as described',
    'Damaged item',
    'Seller not responding',
    'Other issue',
  ];

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: _selectedReason,
      onChanged: (value) => setState(() => _selectedReason = value),
      child: Column(
        children: _reasons.map((reason) {
          return RadioListTile<String>(
            title: Text(reason, style: const TextStyle(fontSize: 14)),
            value: reason,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }).toList(),
      ),
    );
  }
}
