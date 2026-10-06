import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  buyer,
  seller,
}

class AppUser {
  final String id;
  final String phone;
  final String name;
  final UserRole role;
  final bool isProfileComplete;

  final String businessName;
  final String district;
  final double latitude;
  final double longitude;
  final String profilePhoto;
  final String profileType;
  final String village;
  final DateTime? updatedAt;

  const AppUser({
    required this.id,
    required this.phone,
    this.name = '',
    this.role = UserRole.buyer,
    this.isProfileComplete = false,
    this.businessName = '',
    this.district = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.profilePhoto = '',
    this.profileType = '',
    this.village = '',
    this.updatedAt,
  });

  // ============================================================
  // FIREBASE -> APP USER
  // ============================================================

  factory AppUser.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    DateTime? updatedAt;

    final value = map['updatedAt'];

    if (value is Timestamp) {
      updatedAt = value.toDate();
    }

    return AppUser(
      id: id,
      phone: map['phone'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.buyer,
      ),
      isProfileComplete: map['isProfileComplete'] as bool? ?? false,
      businessName: map['businessName'] as String? ?? '',
      district: map['district'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      profilePhoto: map['profilePhoto'] as String? ?? '',
      profileType: map['profileType'] as String? ?? '',
      village: map['village'] as String? ?? '',
      updatedAt: updatedAt,
    );
  }

  // ============================================================
  // APP USER -> FIREBASE
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'name': name,
      'role': role.name,
      'isProfileComplete': isProfileComplete,
      'businessName': businessName,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'profilePhoto': profilePhoto,
      'profileType': profileType,
      'village': village,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  // ============================================================
  // APP USER -> SHARED PREFERENCES
  // ============================================================

  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'role': role.name,
      'isProfileComplete': isProfileComplete,
      'businessName': businessName,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'profilePhoto': profilePhoto,
      'profileType': profileType,
      'village': village,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // ============================================================
  // SHARED PREFERENCES -> APP USER
  // ============================================================

  factory AppUser.fromLocalMap(
    Map<String, dynamic> map,
  ) {
    DateTime? updatedAt;

    final value = map['updatedAt'];

    if (value is String && value.isNotEmpty) {
      updatedAt = DateTime.tryParse(value);
    }

    return AppUser(
      id: map['id'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.buyer,
      ),
      isProfileComplete: map['isProfileComplete'] as bool? ?? false,
      businessName: map['businessName'] as String? ?? '',
      district: map['district'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      profilePhoto: map['profilePhoto'] as String? ?? '',
      profileType: map['profileType'] as String? ?? '',
      village: map['village'] as String? ?? '',
      updatedAt: updatedAt,
    );
  }

  AppUser copyWith({
    String? name,
    UserRole? role,
    bool? isProfileComplete,
    String? businessName,
    String? district,
    double? latitude,
    double? longitude,
    String? profilePhoto,
    String? profileType,
    String? village,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id,
      phone: phone,
      name: name ?? this.name,
      role: role ?? this.role,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      businessName: businessName ?? this.businessName,
      district: district ?? this.district,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      profileType: profileType ?? this.profileType,
      village: village ?? this.village,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
