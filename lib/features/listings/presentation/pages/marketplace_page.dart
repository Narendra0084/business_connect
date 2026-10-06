import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:bihar_business_connect/features/listings/presentation/cubit/listings_cubit.dart';
import 'package:bihar_business_connect/features/listings/presentation/pages/create_listing_page.dart';
import 'package:bihar_business_connect/features/listings/presentation/pages/product_details.dart';
import 'package:bihar_business_connect/features/listings/presentation/widgets/listing_card.dart';
import 'package:bihar_business_connect/features/listings/presentation/widgets/product_search_bottom_sheet.dart';
import 'package:bihar_business_connect/features/orders/presentation/product_save.dart';
import 'package:bihar_business_connect/utility/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/pages/onboarding_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  ListingsCubit cubit = ListingsCubit();
  String orderId = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.init();
    });
  }

  final _searchController = TextEditingController();
  final _districtController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Marketplace',
          style: BBCStyle.boldStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 24),
        ),
        centerTitle: true,
        primary: true,
        leading: SizedBox(),
        actions: [
          IconButton(
            tooltip: 'Orders',
            icon: Icon(Icons.local_shipping_outlined, color: Theme.of(context).scaffoldBackgroundColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OrdersPage(listingId: orderId)),
              );
            },
          ),
          IconButton(
            tooltip: 'Saved',
            icon: Icon(Icons.favorite_border_outlined, color: Theme.of(context).scaffoldBackgroundColor),
            onPressed: () async {
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductSave()),
              );
            },
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: Icon(Icons.logout, color: Theme.of(context).scaffoldBackgroundColor),
            onPressed: () async {
              if (!context.mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingPage()));
            },
          ),
        ],
      ),
      floatingActionButton: Utilities.loginInformation?.role.name == 'buyer'
          ? SizedBox()
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateListingPage()));
              },
              icon: const Icon(Icons.add),
              label: const Text('Listing'),
            ),
      body: AppBackground(
        appBody: BlocBuilder<ListingsCubit, ListingsState>(
            bloc: cubit,
            builder: (context, state) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Hello, ${Utilities.loginInformation?.name}',
                      style: BBCStyle.boldStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 24),
                    ),
                    const SizedBox(height: 10),

                    /// we need here search button and design is when user click search field then screen open from bottom then user search which he want so.
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) {
                            return ProductSearchBottomSheet(listings: state.listings);
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Search products...',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.listings.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          orderId = state.listings[index].id;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListingCard(
                              productList: state.listings[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => ProductDetails(productItem: state.listings[index])),
                                );
                              },
                            ),
                          );
                        })
                  ],
                ),
              );
            }),
      ),
    );
  }
}
