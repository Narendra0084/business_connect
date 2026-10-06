import 'dart:async';

import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:bihar_business_connect/features/orders/domain/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState());
  OrderRepository _orderRepository = OrderRepository.instance;
  StreamSubscription<ProductOrder>? _orderSubscription;

  Future<void> getOrderForListing({required String listingId}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      final order = await _orderRepository.getOrderForListing(listingId: listingId, buyerId: user.uid);

      if (order == null) {
        emit(
          state.copyWith(
            orderId: '',
            orderStatus: null,
          ),
        );
        return;
      }

      // First load current Firebase order details
      emit(
        state.copyWith(
          orderId: order.orderId,
          orderStatus: OrderStatus.values.firstWhere(
            (status) => status.name == order.status,
            orElse: () => OrderStatus.requested,
          ),
        ),
      );

      // Then start real-time listener
      watchOrder(order.orderId);
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> watchOrder(String orderId) async {
    _orderSubscription?.cancel();

    _orderSubscription = _orderRepository.watchOrder(orderId).listen(
      (order) {
        print('Order updated: ${order.orderId}');
        print('Order status: ${order.status}');
        emit(state.copyWith());
      },
      onError: (error) {
        emit(state.copyWith(
          status: OrdersStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }
}
