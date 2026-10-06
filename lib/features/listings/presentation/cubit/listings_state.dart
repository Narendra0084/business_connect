part of 'listings_cubit.dart';

enum ListingsStatus {
  initial,
  loading,
  loaded,
  creating,
  createdSuccess,
  error,
}

class ListingsState extends Equatable {
  final ListingsStatus status;
  final String? errorMessage;
  final AppUser? user;
  final List<Listing> listings;
  final BusinessType? businessType;
  final ProductCategory category;
  final ProductUnit unit;
  final String? productImagePath;
  final bool isInformationCorrect;
  final String searchQuery;
  final String districtFilter;
  final String categoryFilter;
  final String orderId;
  final OrderStatus? orderStatus;
  final List<Listing> saveListings;

  const ListingsState({
    this.status = ListingsStatus.initial,
    this.errorMessage,
    this.user,
    this.listings = const [],
    this.businessType,
    this.category = ProductCategory.agriculture,
    this.unit = ProductUnit.kg,
    this.productImagePath,
    this.isInformationCorrect = false,
    this.orderId = '',
    this.searchQuery = '',
    this.districtFilter = '',
    this.categoryFilter = 'All',
    this.orderStatus,
    this.saveListings = const [],
  });

  bool get isLoading => status == ListingsStatus.loading;
  bool get isCreating => status == ListingsStatus.creating;
  bool get isSuccess => status == ListingsStatus.createdSuccess;
  bool get hasError => status == ListingsStatus.error;
  bool get hasUser => user != null;
  bool get hasProductImage => productImagePath != null && productImagePath!.isNotEmpty;

  ListingsState copyWith(
      {ListingsStatus? status,
      String? errorMessage,
      AppUser? user,
      List<Listing>? listings,
      BusinessType? businessType,
      ProductCategory? category,
      ProductUnit? unit,
      String? productImagePath,
      bool? isInformationCorrect,
      String? searchQuery,
      String? districtFilter,
      String? categoryFilter,
      String? orderId,
      bool clearError = false,
      bool clearUser = false,
      bool clearBusinessType = false,
      bool clearProductImage = false,
      OrderStatus? orderStatus,
      List<Listing>? saveListings}) {
    return ListingsState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: clearUser ? null : (user ?? this.user),
      listings: listings ?? this.listings,
      businessType: clearBusinessType ? null : (businessType ?? this.businessType),
      category: category ?? this.category,
      unit: unit ?? this.unit,
      productImagePath: clearProductImage ? null : (productImagePath ?? this.productImagePath),
      isInformationCorrect: isInformationCorrect ?? this.isInformationCorrect,
      searchQuery: searchQuery ?? this.searchQuery,
      districtFilter: districtFilter ?? this.districtFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      orderId: orderId ?? this.orderId,
      orderStatus: orderStatus ?? this.orderStatus,
      saveListings: saveListings ?? this.saveListings,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        user,
        listings,
        businessType,
        category,
        unit,
        productImagePath,
        isInformationCorrect,
        searchQuery,
        districtFilter,
        categoryFilter,
        orderId,
        orderStatus,
        saveListings
      ];
}
