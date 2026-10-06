import 'dart:async';

import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:bihar_business_connect/features/auth/presentation/pages/otp_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/pages/onboarding_page.dart';
import '../../../listings/presentation/pages/marketplace_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1400), _openNextScreen);
  }

  void _openNextScreen() {
    final user = context.read<AuthCubit>().state.user;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => user == null ? const OnboardingPage() : const MarketplacePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: AppBackground(
        appBody: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.handshake_outlined, size: 46, color: scheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Bihar Business Connect',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Trusted trade from discovery to delivery',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.88),
                  ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
