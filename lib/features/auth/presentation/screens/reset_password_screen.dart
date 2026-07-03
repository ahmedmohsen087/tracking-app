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

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordViewModel, ForgetPasswordState>(
      listenWhen: (previous, current) =>
          previous.forgetPasswordState.isLoading &&
          !current.forgetPasswordState.isLoading,
      listener: (context, state) {
        final apiState = state.forgetPasswordState;

        if (apiState.data != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutsName.loginScreen,
            (route) => false,
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
      child: const _ResetPasswordScaffold(),
    );
  }
}

class _ResetPasswordScaffold extends StatelessWidget {
  const _ResetPasswordScaffold();

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
          child: _ResetPasswordBody(),
        ),
      ),
    );
  }
}

class _ResetPasswordBody extends StatefulWidget {
  const _ResetPasswordBody();

  @override
  State<_ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<_ResetPasswordBody> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordViewModel>().doEvent(
        ResetPasswordEvent(
          requestModel: ForgetPasswordRequestModel(
            newPassword: _passwordController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const _HeaderTexts(),
            const SizedBox(height: 40),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (v) => AppValidations.validatePassword(v ?? ''),
              decoration: InputDecoration(
                labelText: AppStrings.newPassword.tr(),
                hintText: AppStrings.enterYourPassword.tr(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              validator: (v) => AppValidations.validateConfirmPassword(
                _passwordController.text,
                v ?? '',
              ),
              decoration: InputDecoration(
                labelText: AppStrings.confirmPassword.tr(),
                hintText: AppStrings.confirmPassword.tr(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 40),
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
          AppStrings.resetPassword.tr(),
          style: TextStyles.bodyRegular16.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 250,
          child: Text(
            AppStrings.hitTextForResetPassword.tr(),
            textAlign: TextAlign.center,
            style: TextStyles.hintTextFieldStyle,
          ),
        ),
      ],
    );
  }
}
