import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/app_user.dart';
import '../../domain/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  Timer? _resendTimer;

  AuthCubit(this._authRepository) : super(const AuthState());

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> sendOtp({required String phone, required UserRole role}) async {
    print("SendOtp button Pressed");
    emit(state.copyWith(status: AuthStatus.sendingOtp, role: role, errorMessage: null));
    try {
      final verificationId = await _authRepository.sendOtp(phone);
      emit(state.copyWith(status: AuthStatus.otpSent, verificationId: verificationId));
      _startResendCooldown();
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (state.verificationId == null) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Please request OTP again.'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.verifyingOtp, errorMessage: null));
    try {
      final user = await _authRepository.verifyOtp(verificationId: state.verificationId!, otp: otp, role: state.role);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> resendOtp(String phone) async {
    if (state.resendCooldown > 0) return;
    await sendOtp(phone: phone, role: state.role);
  }

  void resetToPhoneEntry() {
    _resendTimer?.cancel();
    emit(const AuthState());
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    emit(state.copyWith(resendCooldown: 30));
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCooldown <= 1) {
        timer.cancel();
        emit(state.copyWith(resendCooldown: 0));
      } else {
        emit(state.copyWith(resendCooldown: state.resendCooldown - 1));
      }
    });
  }

  Future<void> takeLivePhoto() async {
    if (state.isTakingPhoto) return;
    emit(state.copyWith(isTakingPhoto: true, clearError: true));
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1200, maxHeight: 1200);
      if (pickedFile == null) {
        emit(state.copyWith(isTakingPhoto: false));
        return;
      }
      emit(state.copyWith(profilePhoto: File(pickedFile.path), isTakingPhoto: false));
    } catch (e) {
      emit(state.copyWith(isTakingPhoto: false, errorMessage: 'Unable to capture photo: $e'));
    }
  }

  Future<void> getCurrentLocation() async {
    if (state.isGettingLocation) return;
    emit(state.copyWith(isGettingLocation: true, clearError: true));
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
          'Location service is disabled. Please enable GPS/location.',
        );
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is permanently denied. '
          'Please enable it from app settings.',
        );
      }
      final Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      final List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isEmpty) {
        throw Exception('Could not find address for this location.');
      }
      final Placemark place = placemarks.first;
      final String villageOrCity = _firstNonEmpty([place.locality, place.subLocality, place.subAdministrativeArea]);
      final String district = _firstNonEmpty([place.subAdministrativeArea, place.administrativeArea, place.locality]);
      emit(state.copyWith(latitude: position.latitude, longitude: position.longitude, village: villageOrCity, district: district, isGettingLocation: false));
    } catch (e) {
      emit(state.copyWith(isGettingLocation: false, errorMessage: 'Unable to get location: $e'));
    }
  }

  String _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return '';
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  Future<void> saveProfile(
      {required String profileType,
      required String name,
      required String businessName,
      required String village,
      required String district,
      required double latitude,
      required double longitude,
      required File profilePhoto}) async {
    emit(state.copyWith(status: AuthStatus.verifyingOtp, clearError: true));
    try {
      await _authRepository.profileInformationSave(
        profileType: profileType,
        name: name,
        businessName: businessName,
        village: village,
        district: district,
        latitude: latitude,
        longitude: longitude,
        profilePhotoPath: profilePhoto.path,
      );

      emit(state.copyWith(status: AuthStatus.profileDone));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
