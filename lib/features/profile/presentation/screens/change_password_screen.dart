import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context) {
    context.read<ChangePasswordViewModel>().doEvent(EnableAutoValidateEvent());
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordViewModel>().doEvent(
        ChangePasswordRequestEvent(
          password: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            Assets.assetsIconsArrowBack,
            width: 24,
            height: 24,
            matchTextDirection: true,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.resetPassword,
          style: TextStyles.appBarTextStyle,
        ),
      ),
      body: BlocListener<ChangePasswordViewModel, ChangePasswordState>(
        listener: (context, state) async {
          if (!state.changePasswordState.isLoading &&
              state.changePasswordState.data != null) {
            AppSnackBar.showSuccess(context, AppStrings.passwordUpdated);
            await getIt<AuthManager>().logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutsName.loginScreen,
                (route) => false,
              );
            }
          } else if (!state.changePasswordState.isLoading &&
              state.changePasswordState.msg != null) {
            AppSnackBar.showError(context, state.changePasswordState.msg!);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<ChangePasswordViewModel, ChangePasswordState>(
              buildWhen: (prev, curr) =>
                  prev.autoValidate != curr.autoValidate ||
                  prev.changePasswordState.isLoading !=
                      curr.changePasswordState.isLoading,
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  autovalidateMode: state.autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _PasswordField(
                        controller: _currentPasswordController,
                        label: AppStrings.currentPassword,
                        hint: AppStrings.currentPassword,
                        validator: (v) =>
                            AppValidations.validatePassword(v ?? ''),
                      ),
                      const SizedBox(height: 16),
                      _PasswordField(
                        controller: _newPasswordController,
                        label: AppStrings.newPassword,
                        hint: AppStrings.newPassword,
                        validator: (v) =>
                            AppValidations.validatePassword(v ?? ''),
                      ),
                      const SizedBox(height: 16),
                      _PasswordField(
                        controller: _confirmPasswordController,
                        label: AppStrings.confirmPassword,
                        hint: AppStrings.confirmPassword,
                        validator: (v) =>
                            AppValidations.validateConfirmPassword(
                              _newPasswordController.text,
                              v ?? '',
                            ),
                      ),
                      const SizedBox(height: 32),
                      _UpdateButton(
                        isLoading: state.changePasswordState.isLoading,
                        onPressed: () => _onUpdate(context),
                        currentController: _currentPasswordController,
                        newController: _newPasswordController,
                        confirmController: _confirmPasswordController,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?) validator;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _UpdateButton extends StatefulWidget {
  const _UpdateButton({
    required this.isLoading,
    required this.onPressed,
    required this.currentController,
    required this.newController,
    required this.confirmController,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final TextEditingController currentController;
  final TextEditingController newController;
  final TextEditingController confirmController;

  @override
  State<_UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<_UpdateButton> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.currentController.addListener(_checkFields);
    widget.newController.addListener(_checkFields);
    widget.confirmController.addListener(_checkFields);
  }

  void _checkFields() {
    final enabled =
        widget.currentController.text.isNotEmpty &&
        widget.newController.text.isNotEmpty &&
        widget.confirmController.text.isNotEmpty;

    if (enabled != _isEnabled) {
      setState(() => _isEnabled = enabled);
    }
  }

  @override
  void dispose() {
    widget.currentController.removeListener(_checkFields);
    widget.newController.removeListener(_checkFields);
    widget.confirmController.removeListener(_checkFields);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.4),
        ),
        onPressed: widget.isLoading || !_isEnabled ? null : widget.onPressed,
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(AppStrings.update),
      ),
    );
  }
}
