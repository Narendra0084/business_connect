import 'package:cloud_firestore/cloud_firestore.dart';

enum ProductCategory { agriculture, handicraft, textile, foodProcessing, other }

extension ProductCategoryLabel on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.agriculture:
        return 'Agriculture & Food';
      case ProductCategory.handicraft:
        return 'Handicrafts';
      case ProductCategory.textile:
        return 'Textiles';
      case ProductCategory.foodProcessing:
        return 'Food Processing';
      case ProductCategory.other:
        return 'Other';
    }
  }
}

enum ListingStatus { active, sold, inactive }

class Listing {
  final String id; // Firestore listing document ID
  final String userId; // Seller Firebase UID
  final ProductCategory category;
  final String productName;
  final String description;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final String photoUrl;
  final String village;
  final String district;
  final String businessType;
  final DateTime createdAt;
  final String sellerName;
  final String sellerPhoto;

  const Listing({
    required this.id,
    required this.userId,
    required this.category,
    required this.productName,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.photoUrl,
    required this.village,
    required this.district,
    required this.businessType,
    required this.createdAt,
    required this.sellerName,
    required this.sellerPhoto,
  });

  factory Listing.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Listing(
      // Firestore document ID is the source of truth
      id: id,

      userId: map['userId'] ?? '',

      category: ProductCategory.values.firstWhere(
        (category) => category.name == map['category'],
        orElse: () => ProductCategory.other,
      ),

      productName: map['productName'] ?? '',
      description: map['description'] ?? '',

      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,

      unit: map['unit'] ?? 'kg',

      pricePerUnit: (map['pricePerUnit'] as num?)?.toDouble() ?? 0.0,

      photoUrl: map['photoUrl'] ?? '',
      village: map['village'] ?? '',
      district: map['district'] ?? '',
      businessType: map['businessType'] ?? '',

      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),

      sellerName: map['sellerName'] ?? '',
      sellerPhoto: map['sellerPhoto'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category.name,
      'productName': productName,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'photoUrl': photoUrl,
      'village': village,
      'district': district,
      'businessType': businessType,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
      'sellerPhoto': sellerPhoto,
      'sellerName': sellerName,
    };
  }

  Listing copyWith({
    String? id,
    String? userId,
    ProductCategory? category,
    String? productName,
    String? description,
    double? quantity,
    String? unit,
    double? pricePerUnit,
    String? photoUrl,
    String? village,
    String? district,
    String? businessType,
    DateTime? createdAt,
    String? sellerName,
    String? sellerPhoto,
  }) {
    return Listing(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      photoUrl: photoUrl ?? this.photoUrl,
      village: village ?? this.village,
      district: district ?? this.district,
      businessType: businessType ?? this.businessType,
      createdAt: createdAt ?? this.createdAt,
      sellerName: sellerName ?? this.sellerName,
      sellerPhoto: sellerPhoto ?? this.sellerPhoto,
    );
  }
}
