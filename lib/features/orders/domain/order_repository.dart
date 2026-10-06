import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  OrderRepository._internal();

  static final OrderRepository instance = OrderRepository._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   CollectionReference<Map<String, dynamic>> get _orders => _firestore.collection('orders');

  Future<ProductOrder?> getOrderForListing({
    required String listingId,
    required String buyerId,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('listingId', isEqualTo: listingId)
        .where('buyerId', isEqualTo: buyerId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return ProductOrder.fromMap(
      snapshot.docs.first.data(),
    );
  }
  
  Stream<ProductOrder> watchOrder(String orderId) {
    return _orders.doc(orderId).snapshots().map(
      (snapshot) {
        return ProductOrder.fromMap(
          snapshot.data()!,
        );
      },
    );
  }
}
