import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/auth_state.dart';

class VerificationCodeScreen extends StatelessWidget {
  final String email;
  final otbController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  VerificationCodeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(AppStrings.password,
              style: TextStyles.appBarTextStyle,
            ),
          ],
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            Navigator.pushNamed(
              context,
              AppRoutsName.resetPassword,
              arguments: email,
            );
          } else if (state is VerifyOtpError) {
            AppSnackBar.showError(context, state.message);
          } else if (state is ForgetPasswordSuccess) {
            AppSnackBar.showSuccess(context, 'Verification code resent successfully');
          } else if (state is ForgetPasswordError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 30,
                children: [
                  Text(AppStrings.emailVerification,
                    style: TextStyles.bodyMedium18,
                  ),
                  Text(AppStrings.pleaseEnterYourCode,
                    textAlign: TextAlign.center,
                    style: TextStyles.hintTextFieldStyle.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  if (state is VerifyOtpLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Pinput(
                      length: 4,
                      validator: (value) => AppValidations.validateOtp(value ?? ''),
                      controller: otbController,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.whiteGrey,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.grey),
                        ),
                        textStyle: TextStyles.textFieldTextStyle,
                      ),
                      focusedPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.pink),
                        ),
                        textStyle: TextStyles.textFieldTextStyle,
                      ),
                      onCompleted: (value) {
                        context.read<AuthCubit>().verifyOtp(
                          email: email,
                          otp: value,
                        );
                      },
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.didntReceiveCode,
                        style: TextStyles.bodyRegular16,
                      ),
                      if (state is ForgetPasswordLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        InkWell(
                          onTap: () {
                            context.read<AuthCubit>().forgetPassword(email);
                          },
                          child: Text(AppStrings.resend,
                            style: TextStyles.bodyRegular16.copyWith(
                              color: AppColors.pink,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
