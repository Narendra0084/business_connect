// class InMemoryOrderRepository implements OrderRepository {
//   final List<Order> _orders = [
//     Order(
//       id: 'order-1',
//       listingId: 'listing-1',
//       sellerId: 'seller-1',
//       buyerId: 'buyer-1',
//       productName: 'Premium Makhana',
//       quantity: 5,
//       unit: 'quintal',
//       finalPrice: 59000,
//       deliveryType: DeliveryType.platformTransport,
//       pickupLocation: 'Benipatti, Madhubani',
//       dropLocation: 'Patna Wholesale Market',
//       deliveryDate: DateTime.now().add(const Duration(days: 5)),
//       status: OrderStatus.confirmed,
//     ),
//   ];

//   @override
//   Future<List<Order>> fetchOrders() async {
//     await Future<void>.delayed(const Duration(milliseconds: 250));
//     return List.unmodifiable(_orders);
//   }

//   @override
//   Future<Order> confirmOrder(Order order) async {
//     _orders.insert(0, order);
//     return order;
//   }

//   // @override
//   // Future<Order> updateStatus({
//   //   required String orderId,
//   //   required OrderStatus status,
//   // }) async {
//   //   final index = _orders.indexWhere((order) => order.id == orderId);
//   //   if (index == -1) {
//   //     throw StateError('Order not found');
//   //   }
//   //   _orders[index] = _orders[index].copyWith(status: status);
//   //   return _orders[index];
//   // }
// }
