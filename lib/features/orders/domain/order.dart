import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.listingId,
    required this.sellerId,
    required this.buyerId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.finalPrice,
    required this.deliveryType,
    required this.deliveryDate,
    required this.status,
    this.pickupLocation,
    this.dropLocation,
  });

  final String id;
  final String listingId;
  final String sellerId;
  final String buyerId;
  final String productName;
  final double quantity;
  final String unit;
  final double finalPrice;
  final DeliveryType deliveryType;
  final String? pickupLocation;
  final String? dropLocation;
  final DateTime deliveryDate;
  final OrderStatus status;

  Order copyWith({
    OrderStatus? status,
    DateTime? deliveryDate,
  }) {
    return Order(
      id: id,
      listingId: listingId,
      sellerId: sellerId,
      buyerId: buyerId,
      productName: productName,
      quantity: quantity,
      unit: unit,
      finalPrice: finalPrice,
      deliveryType: deliveryType,
      pickupLocation: pickupLocation,
      dropLocation: dropLocation,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listingId,
        sellerId,
        buyerId,
        productName,
        quantity,
        unit,
        finalPrice,
        deliveryType,
        pickupLocation,
        dropLocation,
        deliveryDate,
        status,
      ];
}

enum DeliveryType { sellerDelivers, collectionPoint, platformTransport }

extension DeliveryTypeLabel on DeliveryType {
  String get label {
    switch (this) {
      case DeliveryType.sellerDelivers:
        return 'Seller delivers';
      case DeliveryType.collectionPoint:
        return 'Collection point';
      case DeliveryType.platformTransport:
        return 'Platform transport';
    }
  }
}
