import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/orders/domain/order_repository.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/reputation/domain/reputation_repository.dart';
import 'features/reputation/presentation/cubit/reputation_cubit.dart';
import 'features/splash/presentation/pages/splash_page.dart';

class BiharBusinessConnectApp extends StatelessWidget {
  const BiharBusinessConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(context.read<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) => OrdersCubit(),
        ),
        BlocProvider(
          create: (context) => ReputationCubit(
            context.read<ReputationRepository>(),
          )..loadRatings(),
        ),
      ],
      child: MaterialApp(
        title: 'Bihar Business Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
