import 'package:bihar_business_connect/common_widgets/description_text.dart';
import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:bihar_business_connect/utility/utilities.dart';
import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final Listing productList;
  const ListingCard({required this.onTap, super.key, required this.productList});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      productList.productName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(Utilities.timeAgo(productList.createdAt)),
                ],
              ),
              const SizedBox(height: 6),
              DescriptionText(description: productList.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(productList.category.name)),
                  Chip(label: Text('${productList.quantity} ${productList.unit}')),
                  Chip(label: Text('Rs ${productList.pricePerUnit}')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(
                    '${productList.village}, ${productList.district}',
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
                  Icon(Icons.star, size: 18, color: Colors.amber),
                  Text(
                    ' ${5} (${3})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
