import 'dart:io';

import 'package:bihar_business_connect/common_widgets/appBar_with_back_button.dart';
import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/common_widgets/required_dropdown_widgets.dart';
import 'package:bihar_business_connect/common_widgets/required_input_field.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:bihar_business_connect/features/listings/data/enum.dart';
import 'package:bihar_business_connect/features/listings/domain/model/create_request_model.dart';
import 'package:bihar_business_connect/features/listings/domain/model/listing.dart';
import 'package:bihar_business_connect/features/listings/presentation/cubit/listings_cubit.dart';
import 'package:bihar_business_connect/utility/image_picker_utils.dart';
import 'package:bihar_business_connect/utility/input_validator.dart';
import 'package:bihar_business_connect/utility/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();
  ListingsCubit cubit = ListingsCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        appBody: Form(
          key: _formKey,
          child: BlocListener<ListingsCubit, ListingsState>(
            bloc: cubit,
            listener: (context, state) {
              if (state.status == ListingsStatus.error && state.errorMessage != null) {
                _showError(state.errorMessage!);
              }
              if (state.status == ListingsStatus.createdSuccess) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listing published successfully.'),
                  ),
                );
              }
            },
            child: BlocBuilder<ListingsCubit, ListingsState>(
              bloc: cubit,
              builder: (context, state) {
                return AppBarWithBackButton(
                    screenBody: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "With buyers, both domestic and international. Unlike a simple listing app, the platform positions itself as a trust and fulfillment layer: it does not just introduce two parties and step away. It manages the relationship from discovery, through a safe first contact, through order confirmation, all the way to delivery.",
                        style: BBCStyle.normalStyle(color: Theme.of(context).secondaryHeaderColor, size: 16),
                      ),
                      SizedBox(height: 16),
                      RequiredDropdownWidgets<BusinessType>(
                        inputHintText: 'Business Type',
                        validationName: 'business type',
                        value: state.businessType,
                        dropdownItems: BusinessType.values.map((type) {
                          return DropdownMenuItem<BusinessType>(
                            value: type,
                            child: Text(type.label),
                          );
                        }).toList(),
                        onChanged: cubit.selectBusinessType,
                      ),
                      const SizedBox(height: 16),
                      RequiredDropdownWidgets<ProductCategory>(
                        inputHintText: 'Business category',
                        validationName: 'business category',
                        value: state.category,
                        dropdownItems: ProductCategory.values.map((type) {
                          return DropdownMenuItem<ProductCategory>(
                            value: type,
                            child: Text(type.label),
                          );
                        }).toList(),
                        onChanged: cubit.selectCategory,
                      ),
                      const SizedBox(height: 16),
                      RequiredField(
                        inputController: cubit.productNameController,
                        inputHintText: 'Product Name',
                        inputValidator: (value) => InputValidator.validateRequired(
                          value,
                          fieldLabel: 'Product Name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description: A detailed description helps buyers understand your product better '
                        'and increases their confidence in placing an order. '
                        'Mention quality, quantity, price, location, packaging, and delivery details.',
                        style: BBCStyle.normalStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 16),
                      ),
                      const SizedBox(height: 10),
                      RequiredField(
                        inputController: cubit.descriptionController,
                        inputHintText: 'Product Description',
                        inputValidator: (value) {
                          final description = value?.trim() ?? '';

                          if (description.isEmpty) {
                            return 'Product Description is required';
                          }

                          if (description.length < 200) {
                            return 'Product Description must be at least 200 characters';
                          }

                          return null;
                        },
                        inoutMaxLiens: 4,
                      ),
                      const SizedBox(height: 16),
                      _buildProductImagePicker(state),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RequiredField(
                              inputController: cubit.quantityController,
                              inputHintText: 'Available Quantity',
                              inputValidator: (value) => InputValidator.validateRequired(
                                value,
                                fieldLabel: 'Available Quantity',
                              ),
                              inputKeyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RequiredDropdownWidgets<ProductUnit>(
                              inputHintText: 'Quantity',
                              validationName: 'Quantity',
                              value: state.unit,
                              dropdownItems: ProductUnit.values.map((type) {
                                return DropdownMenuItem<ProductUnit>(
                                  value: type,
                                  child: Text(type.label),
                                );
                              }).toList(),
                              onChanged: cubit.selectUnit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      RequiredField(
                        inputController: cubit.priceController,
                        inputHintText: 'Price per ${state.unit.label} (₹)',
                        inputValidator: (value) => InputValidator.validateRequired(
                          value,
                          fieldLabel: 'Price per',
                        ),
                        inputKeyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Address : ",
                        style: BBCStyle.normalStyle(color: Colors.white, size: 18),
                      ),
                      Text(
                        "${Utilities.loginInformation?.village}, ${Utilities.loginInformation?.village}",
                        style: BBCStyle.mediumStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 18),
                      ),
                      const SizedBox(height: 24),
                      _buildSellerConfirmation(context, state),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _submit,
                        child: state.isCreating
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Publish Listing',
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your listing may be reviewed before becoming visible to buyers.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImagePicker(ListingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image *',
          style: BBCStyle.mediumStyle(color: Colors.white, size: 16),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickProductImage,
          child: Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: state.productImagePath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 40, color: Theme.of(context).scaffoldBackgroundColor),
                      SizedBox(height: 8),
                      Text(
                        'Add Product Photo',
                        style: BBCStyle.normalStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Use a clear photo of the actual product',
                        style: BBCStyle.normalStyle(color: Theme.of(context).scaffoldBackgroundColor, size: 14),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(state.productImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  _buildSellerConfirmation(BuildContext context, ListingsState state) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: state.isInformationCorrect,
      onChanged: (value) {
        cubit.setInformationCorrect(value ?? false);
      },
      title: Text(
        'I confirm that the product information, quantity, price and photo are genuine and accurate.',
        style: BBCStyle.normalStyle(
          color: Theme.of(context).hintColor,
          size: 14,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Future<void> _pickProductImage() async {
    final imagePath = await ImagePickerUtils.pickFromCamera();

    if (imagePath == null || !mounted) return;

    cubit.setProductImage(imagePath);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      print("Else");
    }

    await cubit.createListing();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
