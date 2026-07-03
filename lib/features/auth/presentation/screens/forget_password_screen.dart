import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
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

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

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
            AppRoutsName.emailVerificationScreen,
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
      child: const _ForgetPasswordScaffold(),
    );
  }
}

class _ForgetPasswordScaffold extends StatelessWidget {
  const _ForgetPasswordScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          AppStrings.password.tr(),
          style: TextStyles.appBarTextStyle,
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _ForgetPasswordBody(),
        ),
      ),
    );
  }
}

class _ForgetPasswordBody extends StatefulWidget {
  const _ForgetPasswordBody();

  @override
  State<_ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<_ForgetPasswordBody> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordViewModel>().doEvent(
        SendForgetPasswordEmailEvent(
          requestModel: ForgetPasswordRequestModel(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const _HeaderTexts(),
          const SizedBox(height: 40),
          TextFormField(
            controller: _emailController,
            validator: (v) => AppValidations.validateEmail(v ?? ''),
            decoration: InputDecoration(
              labelText: AppStrings.email.tr(),
              hintText: AppStrings.enterYourEmail.tr(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 32),
          BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
            builder: (context, state) {
              final isLoading = state.forgetPasswordState.isLoading;
              return SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(AppStrings.confirm.tr()),
                ),
              );
            },
          ),
        ],
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
        Text(AppStrings.forgetPassword, style: TextStyles.appBarTextStyle),
        const SizedBox(height: 12),
        Text(
          AppStrings.pleaseEnterYourEmailAssociatedToYourAccount,
          textAlign: TextAlign.center,
          style: TextStyles.hintTextFieldStyle,
        ),
      ],
    );
  }
}
