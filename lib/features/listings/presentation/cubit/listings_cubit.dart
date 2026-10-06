import 'dart:async';

import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:bihar_business_connect/features/listings/data/enum.dart';
import 'package:bihar_business_connect/features/listings/domain/image_repository.dart';
import 'package:bihar_business_connect/features/listings/domain/listing_repository.dart';
import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:bihar_business_connect/utility/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'listings_state.dart';

class ListingsCubit extends Cubit<ListingsState> {
  final ListingRepository _listingRepository = ListingRepository.instance;
  final ImageRepository _imageRepository = ImageRepository.instance;
  StreamSubscription<ProductOrder>? _orderSubscription;
  ListingsCubit() : super(ListingsState());

  static const double minimumQuantityKg = 100;
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  init() async {
    await fetchUserInformation();
    fetchListings();
  }

  Future<void> fetchUserInformation() async {
    emit(state.copyWith(status: ListingsStatus.loading, clearError: true));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'User is not logged in.'));
        return;
      }
      final userInfo = await _listingRepository.getUserDetails(uid);
      if (userInfo == null) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'User information not found.'));
        return;
      }
      final saved = await Utilities.saveLoginInformation(userInfo);
      if (!saved) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'User fetched but failed to save locally.'));
        return;
      }
      emit(state.copyWith(status: ListingsStatus.loaded, user: userInfo));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: ListingsStatus.error, errorMessage: e.message ?? e.code));
    } catch (e) {
      emit(state.copyWith(status: ListingsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> fetchListings() async {
    emit(state.copyWith(status: ListingsStatus.loading, clearError: true));
    try {
      final listings = await _listingRepository.getListings();
      if (listings.isNotEmpty) {
        print('First listing: ${listings.first}');
      } else {
        print('No listings found');
      }

      emit(state.copyWith(status: ListingsStatus.loaded, listings: listings, clearError: true));

      print('Cubit status: loaded');
      print('========== FETCH LISTINGS END ==========');
    } catch (e, stackTrace) {
      print('FETCH LISTINGS ERROR: $e');
      print('STACK TRACE: $stackTrace');

      emit(state.copyWith(status: ListingsStatus.error, errorMessage: e.toString()));

      print('Cubit status: error');
    }
  }

  Future<void> createListing() async {
    try {
      final imagePath = state.productImagePath;
      if (imagePath == null || imagePath.isEmpty) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'Please capture a product image.'));
        return;
      }

      if (!state.isInformationCorrect) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'Please confirm that the product information is correct.'));
        return;
      }

      emit(state.copyWith(status: ListingsStatus.creating, clearError: true));

      final user = Utilities.loginInformation;

      if (user == null || user.id.isEmpty) {
        throw Exception('User information is not available.');
      }

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('Firebase user is not authenticated.');
      }
      final photoUrl = await _imageRepository.uploadListingImage(userId: firebaseUser.uid, imagePath: imagePath);
      final listing = Listing(
        userId: user.id,
        category: state.category,
        productName: productNameController.text.trim(),
        description: descriptionController.text.trim(),
        quantity: double.tryParse(quantityController.text.trim()) ?? 0.0,
        unit: state.unit.label,
        pricePerUnit: double.tryParse(priceController.text.trim()) ?? 0.0,
        village: user.village ?? '',
        district: user.district ?? '',
        businessType: state.businessType!.label,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
        sellerName: user.name,
        sellerPhoto: user.profilePhoto,
        id: '',
      );

      final created = await _listingRepository.createListingRepo(listing);

      emit(state.copyWith(status: ListingsStatus.createdSuccess, listings: [created, ...state.listings], clearError: true));
    } catch (e, stackTrace) {
      debugPrint('Create Listing Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(state.copyWith(status: ListingsStatus.error, errorMessage: _getErrorMessage(e)));
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }

  void selectBusinessType(BusinessType? value) {
    emit(state.copyWith(businessType: value));
  }

  void selectCategory(ProductCategory? value) {
    emit(state.copyWith(category: value));
  }

  void selectUnit(ProductUnit? value) {
    emit(state.copyWith(unit: value));
  }

  void setProductImage(String imagePath) {
    emit(state.copyWith(productImagePath: imagePath));
  }

  void removeProductImage() {
    emit(state.copyWith(clearProductImage: true));
  }

  void setInformationCorrect(bool value) {
    emit(state.copyWith(isInformationCorrect: value));
  }

  String orderStatus(OrderStatus status) {
    return status.name;
  }

  Future<void> productOrderButton({required Listing listing, required double quantity}) async {
    try {
      final user = Utilities.loginInformation;
      if (user == null) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'Please login first'));
        return;
      }
      if (user.profileType != 'buyer') {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'Only buyers can place orders.'));
        return;
      }
      if (quantity <= 0) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'Quantity must be greater than zero.'));
        return;
      }
      emit(state.copyWith(status: ListingsStatus.loading, clearError: true));
      final orderId = await _listingRepository.createOrder(listing: listing, buyerId: user.id, sellerId: listing.userId, quantity: quantity);

      emit(state.copyWith(status: ListingsStatus.createdSuccess, orderId: orderId, orderStatus: OrderStatus.requested, clearError: true));

      watchOrder(orderId);
    } catch (e) {
      emit(state.copyWith(status: ListingsStatus.error, errorMessage: e.toString()));
    }
  }

  void watchOrder(String orderId) {
    _orderSubscription?.cancel();

    _orderSubscription = _listingRepository.watchOrder(orderId).listen(
      (order) {
        emit(
          state.copyWith(
            orderId: order.orderId,
            orderStatus: OrderStatus.values.firstWhere(
              (status) => status.name == order.status,
              orElse: () => OrderStatus.requested,
            ),
            clearError: true,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: ListingsStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await _listingRepository.updateOrderStatus(
        orderId: orderId,
        status: OrderStatus.waitingBuyerConfirmation,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ListingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> rejectOrder(String orderId) async {
    try {
      await _listingRepository.updateOrderStatus(
        orderId: orderId,
        status: OrderStatus.rejected,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ListingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> confirmOrder(String orderId) async {
    try {
      await _listingRepository.updateOrderStatus(
        orderId: orderId,
        status: OrderStatus.confirmed,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ListingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> startShipment(String orderId) async {
    try {
      await _listingRepository.updateOrderStatus(
        orderId: orderId,
        status: OrderStatus.preparingShipment,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ListingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  String getOrderButtonLabel(OrderStatus? status) {
    switch (status) {
      case OrderStatus.requested:
        return 'Waiting for Seller';

      case OrderStatus.waitingBuyerConfirmation:
        return 'Confirm Order';

      case OrderStatus.confirmed:
        return 'Order Confirmed';

      case OrderStatus.preparingShipment:
        return 'Preparing Shipment';

      case OrderStatus.shipped:
        return 'Shipped';

      case OrderStatus.delivered:
        return 'Delivered';

      case OrderStatus.rejected:
        return 'Order Rejected';

      case OrderStatus.cancelled:
        return 'Order Cancelled';

      default:
        return 'Order Now';
    }
  }

  Future<void> getOrderForListing({
    required String listingId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      final order = await _listingRepository.getOrderForListing(
        listingId: listingId,
        buyerId: user.uid,
      );

      if (order == null) {
        emit(
          state.copyWith(
            orderId: '',
            orderStatus: null,
          ),
        );
        return;
      }

      // First load current Firebase order details
      emit(
        state.copyWith(
          orderId: order.orderId,
          orderStatus: OrderStatus.values.firstWhere(
            (status) => status.name == order.status,
            orElse: () => OrderStatus.requested,
          ),
          clearError: true,
        ),
      );

      // Then start real-time listener
      watchOrder(order.orderId);
    } catch (e) {
      emit(
        state.copyWith(
          status: ListingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> savedButtonListing({required Listing saveListing, required BuildContext context}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Utilities.showSnackBar(
          context,
          'Please login first',
        );
        return;
      }

      await _listingRepository.saveListing(
        listing: saveListing,
        buyerId: user.uid,
      );

      Utilities.showSnackBar(context, 'Saved Successfully');
    } catch (e, stackTrace) {
      debugPrint('Save Listing Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          status: ListingsStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> fetchSaveList() async {
    emit(state.copyWith(status: ListingsStatus.loading, clearError: true));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'User is not logged in.'));
        return;
      }
      final saveList = await _listingRepository.getSaveProductList(userId: uid);
      if (saveList == null) {
        emit(state.copyWith(status: ListingsStatus.error, errorMessage: 'User information not found.'));
        return;
      }
      emit(state.copyWith(status: ListingsStatus.loaded, saveListings: saveList));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: ListingsStatus.error, errorMessage: e.message ?? e.code));
    } catch (e) {
      emit(state.copyWith(status: ListingsStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }
}
