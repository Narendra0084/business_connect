import 'package:bihar_business_connect/common_widgets/app_background.dart';
import 'package:bihar_business_connect/common_widgets/required_input_field.dart';
import 'package:bihar_business_connect/core/constants/aap_style.dart';
import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:bihar_business_connect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bihar_business_connect/features/auth/presentation/pages/otp_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  UserRole _role = UserRole.buyer;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          print("state===========");
          print(state);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VerifyUserDetail(role: state.role)),
          );
        } else if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        body: AppBackground(
          appBody: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final otpVisible = state.status == AuthStatus.otpSent || state.status == AuthStatus.verifyingOtp;
                    final isBusy = state.status == AuthStatus.sendingOtp || state.status == AuthStatus.verifyingOtp;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Bihar Business Connect',
                          style: BBCStyle.boldStyle(color: Theme.of(context).colorScheme.surface, size: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Verified discovery, safe contact, and delivery accountability for Bihar trade.',
                          style: BBCStyle.normalStyle(color: Theme.of(context).colorScheme.surface, size: 16),
                        ),
                        const SizedBox(height: 24),
                        IgnorePointer(
                          ignoring: otpVisible,
                          child: Opacity(
                            opacity: otpVisible ? 0.5 : 1.0,
                            child: SegmentedButton<UserRole>(
                              segments: const [
                                ButtonSegment<UserRole>(value: UserRole.buyer, label: Text('Buyer')),
                                ButtonSegment<UserRole>(value: UserRole.seller, label: Text('Seller')),
                              ],
                              selected: {_role},
                              onSelectionChanged: (selection) {
                                setState(() => _role = selection.first);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Theme.of(context).primaryColor;
                                  }
                                  return Theme.of(context).disabledColor;
                                }),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                side: WidgetStateProperty.all(
                                  BorderSide(color: Theme.of(context).splashColor),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        RequiredField(
                          inputController: _phoneController,
                          inputHintText: 'Phone number',
                          inputKeyboardType: TextInputType.phone,
                          inputObscureText: otpVisible,
                        ),
                        if (otpVisible) ...[
                          const SizedBox(height: 12),
                          RequiredField(
                            inputController: _otpController,
                            inputHintText: 'Enter OTP',
                            inputKeyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: state.resendCooldown > 0 ? null : () => context.read<AuthCubit>().resendOtp(_phoneController.text),
                              child: Text(
                                state.resendCooldown > 0 ? 'Resend OTP in ${state.resendCooldown}s' : 'Resend OTP',
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: isBusy ? null : _submit,
                          child: isBusy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(otpVisible ? 'Verify & Continue' : 'Send OTP'),
                        ),
                        if (otpVisible)
                          TextButton(
                            onPressed: () {
                              _otpController.clear();
                              context.read<AuthCubit>().resetToPhoneEntry();
                            },
                            child: const Text('Change Number'),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final cubit = context.read<AuthCubit>();
    final phone = _phoneController.text.trim();
    try {
      if (cubit.state.status == AuthStatus.otpSent) {
        final otp = _otpController.text.trim();
        if (otp.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter OTP')));
          return;
        }
        await cubit.verifyOtp(otp);
      } else {
        if (phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter phone number')),
          );
          return;
        }
        await cubit.sendOtp(phone: phone, role: _role);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    }
  }
}
