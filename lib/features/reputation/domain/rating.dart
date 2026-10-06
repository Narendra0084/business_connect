import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  const Rating({
    required this.id,
    required this.orderId,
    required this.fromUserId,
    required this.toUserId,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String orderId;
  final String fromUserId;
  final String toUserId;
  final int stars;
  final String comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        orderId,
        fromUserId,
        toUserId,
        stars,
        comment,
        createdAt,
      ];
}
