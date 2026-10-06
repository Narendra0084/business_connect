part of 'auth_cubit.dart';

enum AuthStatus { initial, sendingOtp, otpSent, verifyingOtp, authenticated, error, profileDone }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserRole role;
  final String? verificationId;
  final String? errorMessage;
  final int resendCooldown;
  final AppUser? user;

  /// User Personal Information.
  final bool isGettingLocation;
  final bool isTakingPhoto;
  final File? profilePhoto;
  final double? latitude;
  final double? longitude;
  final String village;
  final String district;

  const AuthState({
    this.status = AuthStatus.initial,
    this.role = UserRole.buyer,
    this.verificationId,
    this.errorMessage,
    this.resendCooldown = 0,
    this.user,
    this.isGettingLocation = false,
    this.isTakingPhoto = false,
    this.profilePhoto,
    this.latitude,
    this.longitude,
    this.village = '',
    this.district = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    UserRole? role,
    String? verificationId,
    String? errorMessage,
    int? resendCooldown,
    AppUser? user,
    bool? isGettingLocation,
    bool? isTakingPhoto,
    File? profilePhoto,
    double? latitude,
    double? longitude,
    String? village,
    String? district,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      role: role ?? this.role,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      resendCooldown: resendCooldown ?? this.resendCooldown,
      user: user ?? this.user,
      isGettingLocation: isGettingLocation ?? this.isGettingLocation,
      isTakingPhoto: isTakingPhoto ?? this.isTakingPhoto,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      village: village ?? this.village,
      district: district ?? this.district,
    );
  }

  @override
  List<Object?> get props =>
      [status, role, verificationId, errorMessage, resendCooldown, user, profilePhoto, latitude, longitude, village, district, isGettingLocation, isTakingPhoto];
}
