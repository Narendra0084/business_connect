import 'app_user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  /// Step 1: Firebase sends an SMS with a 6-digit OTP to [phone].
  /// It returns a `verificationId` — a token that identifies THIS
  /// specific OTP request. You must pass it back in step 2 along with
  /// the OTP the user types, so Firebase can match them together.
  Future<String> sendOtp(String phone);

  /// Step 2: confirms the OTP belongs to the verificationId from step 1,
  /// signs the user in, and returns their profile (creating a blank one
  /// in Firestore on first-ever login for this phone number).
  Future<AppUser> verifyOtp({
    required String verificationId,
    required String otp,
    required UserRole role,
  });

  Future<void> signOut();
  Future<String> profileInformationSave({
    required String profileType,
    required String name,
    required String businessName,
    required String village,
    required String district,
    required double latitude,
    required double longitude,
    required String profilePhotoPath,
  });

  Future<AppUser> getCurrentUserProfile();
}
