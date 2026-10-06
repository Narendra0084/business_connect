import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/common_widgets/required_input_field.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:bihar_business_connect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bihar_business_connect/features/listings/presentation/pages/marketplace_page.dart';
import 'package:bihar_business_connect/utility/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyUserDetail extends StatefulWidget {
  final UserRole role;

  const VerifyUserDetail({super.key, required this.role});

  @override
  State<VerifyUserDetail> createState() => _VerifyUserDetailState();
}

class _VerifyUserDetailState extends State<VerifyUserDetail> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _businessController = TextEditingController();

  final TextEditingController _villageController = TextEditingController();

  final TextEditingController _districtController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    _villageController.dispose();
    _districtController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSeller = widget.role == UserRole.seller;

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          _villageController.text = state.village;
          _districtController.text = state.district;
          if (state.status == AuthStatus.profileDone) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplacePage()));
          } else if (state.status == AuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: AppBackground(
          appBody: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 42),
                  Text(
                    isSeller ? 'Tell buyers who you are — this builds trust before they even call you.' : 'Just a few details so sellers know who they\'re talking to.',
                    style: BBCStyle.boldStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),
                  const SizedBox(height: 28),
                  RequiredField(
                    inputController: _nameController,
                    inputHintText: 'Full Name',
                    inputValidator: (value) => InputValidator.validateRequired(
                      value,
                      fieldLabel: 'Name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  RequiredField(
                    inputController: _businessController,
                    inputHintText: 'Business Name',
                    inputValidator: (value) => InputValidator.validateRequired(value, fieldLabel: 'Business name'),
                  ),
                  const SizedBox(height: 12),
                  RequiredField(
                    inputController: _villageController,
                    inputHintText: 'Village / City',
                    inputReadOnly: true,
                    inputValidator: (value) => InputValidator.validateRequired(value, fieldLabel: 'Village/City'),
                  ),
                  const SizedBox(height: 12),
                  RequiredField(
                    inputController: _districtController,
                    inputHintText: 'District',
                    inputReadOnly: true,
                    inputValidator: (value) => InputValidator.validateRequired(
                      value,
                      fieldLabel: 'District',
                    ),
                  ),
                  _buildLocationButton(),
                  const SizedBox(height: 20),
                  _buildContinueButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.profilePhoto != current.profilePhoto || previous.isTakingPhoto != current.isTakingPhoto,
      builder: (context, state) {
        return GestureDetector(
          onTap: state.isTakingPhoto ? null : context.read<AuthCubit>().takeLivePhoto,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).splashColor,
                width: 2,
              ),
            ),
            child: state.profilePhoto == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_enhance_outlined,
                        size: 48,
                        color: Theme.of(context).highlightColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.isTakingPhoto ? 'Opening camera...' : 'Take a live photo',
                        style: BBCStyle.mediumStyle(
                          color: Theme.of(context).hintColor,
                          size: 15,
                        ),
                      ),
                    ],
                  )
                : ClipOval(
                    child: Image.file(
                      state.profilePhoto!,
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLocationButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.isGettingLocation != current.isGettingLocation,
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: state.isGettingLocation ? null : context.read<AuthCubit>().getCurrentLocation,
            icon: state.isGettingLocation
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.my_location,
                    color: Theme.of(context).hintColor,
                  ),
            label: Text(
              state.isGettingLocation ? 'Getting location...' : 'Refresh location',
              style: BBCStyle.normalStyle(
                color: Theme.of(context).hintColor,
                size: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final bool isSaving = state.status == AuthStatus.verifyingOtp;

        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSaving ? null : _submit,
            child: isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Continue'),
          ),
        );
      },
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final state = context.read<AuthCubit>().state;
    if (state.profilePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please take a live photo')));
      return;
    }
    if (state.latitude == null || state.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please allow location access')));
      return;
    }
    context.read<AuthCubit>().saveProfile(
        profileType: state.role.name,
        name: _nameController.text.trim(),
        businessName: _businessController.text.trim(),
        village: state.village,
        district: state.district,
        latitude: state.latitude!,
        longitude: state.longitude!,
        profilePhoto: state.profilePhoto!);
  }
}
