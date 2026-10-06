import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:flutter/material.dart';

class ProductDetailsCard extends StatelessWidget {
  final String title; final Widget child;
  const ProductDetailsCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: BBCStyle.mediumStyle(color: Colors.white, size: 16),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
