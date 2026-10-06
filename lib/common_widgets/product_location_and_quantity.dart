import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:flutter/material.dart';

class ProductLocationAndQuantity extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const ProductLocationAndQuantity({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 10),
          Text(
            title,
            style: BBCStyle.mediumStyle(color: Colors.white, size: 16),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: BBCStyle.normalStyle(color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
