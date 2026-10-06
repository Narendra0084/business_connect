import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageRepository {
  ImageRepository._internal();

  static final ImageRepository instance = ImageRepository._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadListingImage({required String userId, required String imagePath}) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('Product image was not found.');
    }

    final fileName = 'listing_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final storagePath = 'users/$userId/listings/$fileName';

    debugPrint('Storage userId: $userId');
    debugPrint('Storage path: $storagePath');

    final storageRef = _storage.ref().child(storagePath);

    await storageRef.putFile(file, SettableMetadata(contentType: 'image/jpeg'));

    return await storageRef.getDownloadURL();
  }
}
