import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'marketplace_provider.dart';
import 'widgets/product_card_widget.dart';
import 'widgets/cart_badge_widget.dart';
import '../home/widgets/profile_icon_button.dart';
import '../auth/providers/auth_provider.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _initialized = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize category based on persona
    if (!_initialized) {
      final persona = ref.watch(authProvider);
      if (persona != null) {
        _selectedCategory = persona.preferredMarketplaceCategory;
      }
      _initialized = true; // Prevent overwriting user selection
    }

    final productsAsync = ref.watch(marketplaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Image.asset(
                'assets/images/logo.png',
                height: 32,
                fit: BoxFit.contain,
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // ... info dialog remains same
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Fulfillment Options'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFulfillmentOption(
                          context,
                          'Chat on WhatsApp',
                          'Connect directly with the seller to arrange purchase and delivery.',
                          Icons.chat,
                          Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildFulfillmentOption(
                          context,
                          'Buy on Link / Google',
                          'Purchase securely through the seller\'s external store or trusted platform.',
                          Icons.link,
                          Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        _buildFulfillmentOption(
                          context,
                          'Voucher Code',
                          'Get a unique code to redeem on the seller\'s website.',
                          Icons.confirmation_number,
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        _buildFulfillmentOption(
                          context,
                          'Add to Basket',
                          'Add to your Mercur cart and pay directly in the app.',
                          Icons.shopping_cart,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          CartBadgeWidget(),
          SizedBox(width: 8),
          ProfileIconButton(),
          SizedBox(width: 16),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          // 1. Extract Categories (Tags)
          final Set<String> categories = {'All'};
          for (var p in products) {
            categories.addAll(p.tags);
          }
          final sortedCategories = categories.toList()..sort();
          // Ensure 'All' is first
          sortedCategories.remove('All');
          sortedCategories.insert(0, 'All');

          // 2. Filter Products
          final filteredProducts = products.where((p) {
            final matchesCategory =
                _selectedCategory == 'All' ||
                p.tags.contains(_selectedCategory);
            final matchesSearch =
                _searchQuery.isEmpty ||
                p.title.toLowerCase().contains(_searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
          }).toList();

          return Column(
            children: [
              // Filter Bar
              SizedBox(
                height: 60,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: sortedCategories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = sortedCategories[index];
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(
                        category[0].toUpperCase() + category.substring(1),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Theme.of(context).primaryColor,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                    );
                  },
                ),
              ),

              // Product Grid
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'No products found in this category.'
                              : 'No products found for "$_searchQuery".',
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.60,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCardWidget(product: product);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to load marketplace.'),
              const SizedBox(height: 8),
              const Text(
                'Check your network connection',
                style: TextStyle(fontSize: 12),
              ),
              TextButton(
                onPressed: () => ref.refresh(marketplaceProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFulfillmentOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
