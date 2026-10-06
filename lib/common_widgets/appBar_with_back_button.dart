import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:flutter/material.dart';

class AppBarWithBackButton extends StatelessWidget {
  final Widget screenBody;
  const AppBarWithBackButton({super.key, required this.screenBody});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(width: 20),
            Text(
              "Create Product",
              style: BBCStyle.boldStyle(color: Colors.white, size: 32),
            ),
          ],
        ),
        Expanded(child: screenBody)
      ],
    );
  }
}
