import 'package:equatable/equatable.dart';

class CallRequest extends Equatable {
  const CallRequest({
    required this.id,
    required this.listingId,
    required this.buyerId,
    required this.sellerId,
    required this.status,
    required this.requestedAt,
  });

  final String id;
  final String listingId;
  final String buyerId;
  final String sellerId;
  final CallRequestStatus status;
  final DateTime requestedAt;

  @override
  List<Object?> get props => [
        id,
        listingId,
        buyerId,
        sellerId,
        status,
        requestedAt,
      ];
}

enum CallRequestStatus { pending, accepted, rejected }
