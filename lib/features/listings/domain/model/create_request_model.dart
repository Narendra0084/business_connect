import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:equatable/equatable.dart';

class CreateListingRequest extends Equatable {
  final ProductCategory category;
  final String productName;
  final String description;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final String village;
  final String userId;
  final String district;
  final String businessType;
  final String photoUrls;

  const CreateListingRequest({
    required this.userId,
    required this.category,
    required this.productName,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.village,
    required this.district,
    required this.businessType,
    required this.photoUrls,
  });

  @override
  List<Object?> get props => [userId, category, productName, description, quantity, unit, pricePerUnit, village, district, businessType, photoUrls];
}
