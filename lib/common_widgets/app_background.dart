import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget appBody;
  const AppBackground({super.key, required this.appBody});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            scheme.tertiary,
          ],
        ),
      ),
      child: SafeArea(child: appBody),
    );
  }
}
