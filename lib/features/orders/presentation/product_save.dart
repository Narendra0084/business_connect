import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:bihar_business_connect/features/listings/presentation/cubit/listings_cubit.dart';
import 'package:bihar_business_connect/features/listings/presentation/pages/product_details.dart';
import 'package:bihar_business_connect/features/listings/presentation/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSave extends StatefulWidget {
  const ProductSave({super.key});

  @override
  State<ProductSave> createState() => _ProductSaveState();
}

class _ProductSaveState extends State<ProductSave> {
  ListingsCubit cubit = ListingsCubit();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.fetchSaveList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Save Product',
          style: BBCStyle.boldStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 24),
        ),
        centerTitle: true,
        primary: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
      body: AppBackground(
        appBody: BlocBuilder<ListingsCubit, ListingsState>(
            bloc: cubit,
            builder: (context, state) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.saveListings.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListingCard(
                              productList: state.saveListings[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => ProductDetails(productItem: state.saveListings[index])),
                                );
                              },
                            ),
                          );
                        })
                  ],
                ),
              );
            }),
      ),
    );
  }
}
