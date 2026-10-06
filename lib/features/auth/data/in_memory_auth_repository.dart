import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore, this._storage);

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AppUser(id: user.uid, phone: user.phoneNumber ?? '');
  }

  @override
  Future<String> sendOtp(String phone) async {
    print("phone Number: $phone");
    final completer = Completer<String>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (fb.PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (fb.FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e.message ?? 'Failed to send OTP.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
    );

    return completer.future;
  }

  @override
  Future<AppUser> verifyOtp({required String verificationId, required String otp, required UserRole role}) async {
    final credential = fb.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw Exception('Sign-in failed. Please try again.');
    }
    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final doc = await docRef.get();
    if (doc.exists) {
      // Returning user — load their saved profile as-is.
      return AppUser.fromMap(doc.id, doc.data()!);
    }

    // First-ever login for this phone number — create their profile now.
    final newUser = AppUser(
      id: firebaseUser.uid,
      phone: firebaseUser.phoneNumber ?? '',
      role: role,
      isProfileComplete: false,
    );
    await docRef.set(newUser.toMap());
    return newUser;
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<String> profileInformationSave({
    required String profileType,
    required String name,
    required String businessName,
    required String village,
    required String district,
    required double latitude,
    required double longitude,
    required String profilePhotoPath,
  }) async
  {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw Exception('User is not logged in.');
    }
    final uid = firebaseUser.uid;
    try {
      print('1. Starting profile save');
      print('UID: $uid');
      print('Profile Type: $profileType');
      print('Photo: $profilePhotoPath');

      // Upload photo
      final storageRef = _storage.ref().child('users').child(uid).child('profile_photo.jpg');

      print('2. Storage path: ${storageRef.fullPath}');

      await storageRef.putFile(
        File(profilePhotoPath),
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      print('3. Photo uploaded successfully');

      // Get download URL
      final profilePhotoUrl = await storageRef.getDownloadURL();

      print('4. Photo URL: $profilePhotoUrl');

      // Save profile information to Firestore
      await _firestore.collection('users').doc(uid).set(
        {
          'profileType': profileType,
          'name': name,
          'businessName': businessName,
          'village': village,
          'district': district,
          'latitude': latitude,
          'longitude': longitude,
          'profilePhoto': profilePhotoUrl,
          'isProfileComplete': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      print('5. Firestore profile saved successfully');

      return profilePhotoUrl;
    } catch (e, stackTrace) {
      print('PROFILE SAVE ERROR: $e');
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<AppUser> getCurrentUserProfile() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw Exception('No user is currently signed in.');
    }
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (!doc.exists) {
      throw Exception('Profile not found.');
    }
    return AppUser.fromMap(doc.id, doc.data()!);
  }
}
