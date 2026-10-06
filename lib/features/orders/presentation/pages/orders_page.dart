import 'package:bihar_business_connect/features/orders/widgets/order_track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/orders_cubit.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, required this.listingId});
  final String listingId;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrdersCubit cubit = OrdersCubit();
  @override
  initState() {
    super.initState();
    cubit.getOrderForListing(listingId:   widget.listingId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders & Delivery')),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        bloc: cubit,
        builder: (context, state) {
          if (state.status == OrdersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return OrderTrackCard(order: state.orders[index]);
            },
          );
        },
      ),
    );
  }
}
