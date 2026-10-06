import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:bihar_business_connect/features/listings/presentation/pages/product_details.dart';
import 'package:bihar_business_connect/features/listings/presentation/widgets/listing_card.dart';
import 'package:flutter/material.dart';

class ProductSearchBottomSheet extends StatefulWidget {
  const ProductSearchBottomSheet({
    super.key,
    required this.listings,
  });

  final List<Listing> listings;

  @override
  State<ProductSearchBottomSheet> createState() => _ProductSearchBottomSheetState();
}

class _ProductSearchBottomSheetState extends State<ProductSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  List<Listing> _filteredListings = [];

  @override
  void initState() {
    super.initState();

    /// Initially show all available listings.
    _filteredListings = widget.listings;

    /// Listen for every change in the search field.
    _searchController.addListener(_searchProducts);
  }

  void _searchProducts() {
    final query = _searchController.text.trim().toLowerCase();

    /// If search is empty, show all products again.
    if (query.isEmpty) {
      setState(() {
        _filteredListings = widget.listings;
      });
      return;
    }

    /// Search through important product fields.
    ///
    /// You can add more fields here later.
    final results = widget.listings.where((listing) {
      final productName = listing.productName.toLowerCase();

      final description = listing.description.toLowerCase();

      final category = listing.category.name.toLowerCase();

      final district = listing.district.toLowerCase();

      return productName.contains(query) || description.contains(query) || category.contains(query) || district.contains(query);
    }).toList();

    setState(() {
      _filteredListings = results;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchProducts);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            /// Bottom sheet handle.
            const SizedBox(height: 10),

            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            /// Search field.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products, category, district...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Result count.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredListings.length} products found',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// Search results.
            Expanded(
              child: _filteredListings.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      itemCount: _filteredListings.length,
                      itemBuilder: (context, index) {
                        final product = _filteredListings[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: ListingCard(
                            productList: product,
                            onTap: () {
                              /// Close search bottom sheet first.
                              Navigator.pop(context);

                              /// Then open product details.
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetails(productItem: product),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
