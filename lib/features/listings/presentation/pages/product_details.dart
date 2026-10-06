import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/common_widgets/product_details_card.dart';
import 'package:bihar_business_connect/common_widgets/product_location_and_quantity.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:bihar_business_connect/features/listings/presentation/cubit/listings_cubit.dart';
import 'package:bihar_business_connect/utility/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.productItem, this.onBuy, this.onAcceptOrder});
  final Listing productItem;
  final VoidCallback? onBuy;
  final VoidCallback? onAcceptOrder;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ListingsCubit cubit = ListingsCubit();
  @override
  initState() {
    super.initState();
    cubit.getOrderForListing(
      listingId: widget.productItem.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        appBody: SafeArea(
          child: Column(
            children: [
              buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildProductImage(),
                      SizedBox(height: 20),
                      _buildTitleSection(),
                      const SizedBox(height: 20),
                      _buildBasicInfo(),
                      const SizedBox(height: 20),
                      _buildSellerSection(),
                      const SizedBox(height: 20),
                      _buildDescription(),
                      const SizedBox(height: 20),
                      _buildAdditionalInfo(),
                    ],
                  ),
                ),
              ),
              _buildBottomAction(),
            ],
          ),
        ),
      ),
    );
  }

  buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          Expanded(
            child: Text(
              'Product Details',
              style: BBCStyle.boldStyle(color: Colors.white, size: 28),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  buildProductImage() {
    final photoUrl = widget.productItem.photoUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: photoUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Container(height: 220, width: double.infinity, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator()));
        },
        errorWidget: (context, url, error) {
          return Container(height: 220, width: double.infinity, color: Colors.grey.shade200, child: const Icon(Icons.broken_image_outlined, size: 60, color: Colors.grey));
        },
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product Name",
          style: BBCStyle.mediumStyle(color: Colors.white, size: 18),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.productItem.productName,
            style: BBCStyle.normalStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Row(
      children: [
        Expanded(child: ProductLocationAndQuantity(title: "Quantity", value: '${widget.productItem.quantity} Kg', icon: Icons.scale_outlined)),
        SizedBox(width: 12),
        Expanded(child: ProductLocationAndQuantity(title: "Location", value: widget.productItem.district, icon: Icons.location_on_outlined)),
      ],
    );
  }

  Widget _buildSellerSection() {
    return ProductDetailsCard(
      title: 'Seller Info',
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.productItem.sellerPhoto,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(height: 26, width: double.infinity, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator()));
                },
                errorWidget: (context, url, error) {
                  return Container(height: 26, width: double.infinity, color: Colors.grey.shade200, child: const Icon(Icons.broken_image_outlined, size: 60, color: Colors.grey));
                },
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productItem.sellerName,
                  style: BBCStyle.normalStyle(color: Colors.white, size: 16),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.white, size: 14),
                    SizedBox(width: 3),
                    Text(
                      "${widget.productItem.village}, ${widget.productItem.district}",
                      style: BBCStyle.normalStyle(color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return ProductDetailsCard(
      title: 'Product Info',
      child: Text(
        widget.productItem.description,
        style: BBCStyle.normalStyle(color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return ProductDetailsCard(
      title: 'Listing Information',
      child: Column(
        children: [
          _detailRow('Business Type', widget.productItem.category.name),
          const Divider(height: 20),
          _detailRow('Available Quantity', '${widget.productItem.quantity}'),
          const Divider(height: 20),
          _detailRow('Category', widget.productItem.businessType),
          const Divider(height: 20),
          _detailRow('Price/${widget.productItem.unit}', widget.productItem.pricePerUnit.toString()),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: BBCStyle.normalStyle(color: Colors.white, size: 16),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: BBCStyle.normalStyle(color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return BlocListener<ListingsCubit, ListingsState>(
        listener: (context, state) {
          if (state.status == ListingsStatus.error) {
            Utilities.showSnackBar(context, state.errorMessage ?? 'An error occurred');
          } else if (state.status == ListingsStatus.createdSuccess) {
            Utilities.showSnackBar(context, 'Order placed successfully');
            if (widget.onBuy != null) {
              widget.onBuy!();
            }
          }
        },
        bloc: cubit,
        child: BlocBuilder<ListingsCubit, ListingsState>(
            bloc: cubit,
            builder: (context, state) {
              return Column(
                children: [
                  _bottomButton(
                    label: cubit.getOrderButtonLabel(state.orderStatus),
                    icon: Icons.check_circle_outline,
                    btnColor: WidgetStateProperty.all(Colors.blue),
                    onPressed: () {
                      final status = state.orderStatus;

                      if (status == null) {
                        cubit.productOrderButton(
                          listing: widget.productItem,
                          quantity: widget.productItem.quantity,
                        );
                        return;
                      }

                      switch (status) {
                        case OrderStatus.requested:
                          // Waiting for seller.
                          break;

                        case OrderStatus.waitingBuyerConfirmation:
                          cubit.confirmOrder(state.orderId);
                          break;

                        case OrderStatus.accepted:
                          // No action.
                          break;

                        case OrderStatus.confirmed:
                          // No action.
                          break;

                        case OrderStatus.preparingShipment:
                          // No action.
                          break;

                        case OrderStatus.shipped:
                          // No action.
                          break;

                        case OrderStatus.delivered:
                          // No action.
                          break;

                        case OrderStatus.rejected:
                          // Could allow buyer to place a new order.
                          break;

                        case OrderStatus.cancelled:
                          break;
                      }
                    },
                  ),
                  _bottomButton(
                    label: 'Save Listing',
                    icon: Icons.bookmark_border_outlined,
                    btnColor: WidgetStateProperty.all(Theme.of(context).splashColor),
                    onPressed: () {
                      cubit.savedButtonListing(saveListing: widget.productItem, context: context);
                    },
                  ),
                ],
              );
            }));
  }

  Widget _bottomButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    WidgetStateProperty<Color?>? btnColor,
  }) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            style: ButtonStyle(backgroundColor: btnColor),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            label: Text(
              label,
              style: BBCStyle.normalStyle(color: Colors.white, size: 16),
            ),
          ),
        ),
      ),
    );
  }
}
