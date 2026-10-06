import 'dart:io';

import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:bihar_business_connect/utility/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingRepository {
  ListingRepository._internal();

  static final ListingRepository instance = ListingRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('listings');
  CollectionReference<Map<String, dynamic>> get _orders => _firestore.collection('orders');

  Future<List<Listing>> getListings() async {
    try {
      final snapshot = await _collection.get();
      final listings = snapshot.docs.map((doc) {
        final listing = Listing.fromMap(doc.id, doc.data());
        return listing;
      }).toList();
      return listings;
    } catch (e, stackTrace) {
      print('REPOSITORY ERROR: $e');
      print('STACK TRACE: $stackTrace');

      rethrow;
    }
  }

  Future<Listing> createListingRepo(Listing listing) async {
    final docRef = _collection.doc();

    final listingWithId = listing.copyWith(id: docRef.id);

    await docRef.set(listingWithId.toMap());

    return listingWithId;
  }

  Future<void> updateListingStatus(String listingId, ListingStatus status) async {
    await _collection.doc(listingId).update({'status': status.name});
  }

  // GET USER INFORMATION
  Future<AppUser?> getUserDetails(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return AppUser.fromMap(doc.id, doc.data()!);
  }

  Future<String> createOrder({
    required Listing listing,
    required String buyerId,
    required String sellerId,
    required double quantity,
  }) async {
    final doc = _orders.doc();
    final totalAmount = quantity * listing.pricePerUnit;
    await doc.set({
      'orderId': doc.id,
      'listingId': listing.id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productName': listing.productName,
      'quantity': quantity,
      'unit': listing.unit,
      'pricePerUnit': listing.pricePerUnit,
      'totalAmount': totalAmount,
      'status': OrderStatus.requested.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    await _orders.doc(orderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<ProductOrder> watchOrder(
    String orderId,
  ) {
    return _orders.doc(orderId).snapshots().map(
      (snapshot) {
        return ProductOrder.fromMap(
          snapshot.data()!,
        );
      },
    );
  }

  Future<ProductOrder?> getOrderForListing({
    required String listingId,
    required String buyerId,
  }) async {
    final snapshot = await FirebaseFirestore.instance.collection('orders').where('listingId', isEqualTo: listingId).where('buyerId', isEqualTo: buyerId).limit(1).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return ProductOrder.fromMap(
      snapshot.docs.first.data(),
    );
  }

  Future<void> saveListing({required Listing listing, required String buyerId}) async {
    if (listing.userId.isEmpty) {
      throw Exception('Listing ID is missing.');
    }

    await FirebaseFirestore.instance.collection('users').doc(buyerId).collection('savedListings').doc(listing.id).set({
      'listingId': listing.id,

      // Buyer who saved this listing
      'buyerId': buyerId,

      // Original seller
      'sellerId': listing.userId,

      'productName': listing.productName,
      'description': listing.description,

      'quantity': listing.quantity,
      'unit': listing.unit,
      'pricePerUnit': listing.pricePerUnit,

      'category': listing.category.name,
      'businessType': listing.businessType,

      'village': listing.village,
      'district': listing.district,

      'productPhoto': listing.photoUrl,

      'sellerName': listing.sellerName,
      'sellerPhoto': listing.sellerPhoto,

      'savedAt': FieldValue.serverTimestamp(),

      // Original listing creation time
      'createdAt': listing.createdAt,

      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Listing>> getSaveProductList({required String userId}) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('savedListings').get();

    return snapshot.docs.map((doc) {
      return Listing.fromMap(doc.id, doc.data());
    }).toList();
  }
}
