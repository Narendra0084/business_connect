import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderCreating extends OrderState {}

class OrderCreated extends OrderState {
  final String orderId;

  OrderCreated({
    required this.orderId,
  });
}

class OrderUpdated extends OrderState {
  final ProductOrder order;

  OrderUpdated({
    required this.order,
  });
}

class OrderError extends OrderState {
  final String message;

  OrderError({
    required this.message,
  });
}