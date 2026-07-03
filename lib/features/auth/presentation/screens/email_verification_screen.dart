import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_events.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordViewModel, ForgetPasswordState>(
      listenWhen: (previous, current) =>
          previous.forgetPasswordState.isLoading &&
          !current.forgetPasswordState.isLoading,
      listener: (context, state) {
        final apiState = state.forgetPasswordState;

        if (apiState.data != null) {
          Navigator.pushNamed(
            context,
            AppRoutsName.resetPassword,
            arguments: context.read<ForgetPasswordViewModel>(),
          );
        } else if (apiState.msg != null) {
          AppSnackBar.showError(
            context,
            apiState.msg!,
            icon: SvgPicture.asset(
              Assets.assetsIconsError,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      },
      child: const _EmailVerificationScaffold(),
    );
  }
}

class _EmailVerificationScaffold extends StatelessWidget {
  const _EmailVerificationScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
        title: Text(
          AppStrings.password.tr(),
          style: TextStyles.appBarTextStyle,
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 40),
              _HeaderTexts(),
              SizedBox(height: 40),
              _OtpInput(),
              SizedBox(height: 16),
              _ResendRow(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderTexts extends StatelessWidget {
  const _HeaderTexts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.emailVerification.tr(),
          style: TextStyles.appBarTextStyle,
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.pleaseEnterYourEmailAssociatedToYourAccount.tr(),
          textAlign: TextAlign.center,
          style: TextStyles.hintTextFieldStyle,
        ),
      ],
    );
  }
}

class _OtpInput extends StatelessWidget {
  const _OtpInput();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 65,
      height: 65,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey),
      ),
    );

    return BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
      builder: (context, state) {
        final isLoading = state.forgetPasswordState.isLoading;
        return Pinput(
          length: 4,
          defaultPinTheme: defaultPinTheme,
          enabled: !isLoading,
          onCompleted: (pin) {
            context.read<ForgetPasswordViewModel>().doEvent(
              VerifyOtpEvent(
                requestModel: ForgetPasswordRequestModel(resetCode: pin),
              ),
            );
          },
        );
      },
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
      builder: (context, state) {
        final isLoading = state.forgetPasswordState.isLoading;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.didntReciveCode.tr(),
              style: TextStyles.bodyRegular16,
            ),
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      final viewModel = context.read<ForgetPasswordViewModel>();

                      viewModel.doEvent(
                        SendForgetPasswordEmailEvent(
                          requestModel: ForgetPasswordRequestModel(
                            email: viewModel.userEmail,
                          ),
                        ),
                      );
                    },
              child: Text(
                AppStrings.resend.tr(),
                style: TextStyles.bodyRegular16.copyWith(
                  color: AppColors.pink,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
