import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  requested,
  accepted,
  rejected,
  waitingBuyerConfirmation,
  confirmed,
  preparingShipment,
  shipped,
  delivered,
  cancelled,
}

class ProductOrder {
  final String orderId;
  final String listingId;
  final String buyerId;
  final String sellerId;

  final String productName;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double totalAmount;

  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductOrder({
    required this.orderId,
    required this.listingId,
    required this.buyerId,
    required this.sellerId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'listingId': listingId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productName': productName,
      'quantity': quantity,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory ProductOrder.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProductOrder(
      orderId: map['orderId'] ?? '',
      listingId: map['listingId'] ?? '',
      buyerId: map['buyerId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      pricePerUnit: (map['pricePerUnit'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}