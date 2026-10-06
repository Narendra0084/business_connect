part of 'orders_cubit.dart';

enum OrdersStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.orderId,
    this.orderStatus,
  });

  final OrdersStatus status;
  final List<Order> orders;
  final String? errorMessage;
  final String? orderId;
  final OrderStatus? orderStatus;

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    String? errorMessage,
    String? orderId,
    OrderStatus? orderStatus,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      orderId: orderId ?? this.orderId,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage, orderId];
}