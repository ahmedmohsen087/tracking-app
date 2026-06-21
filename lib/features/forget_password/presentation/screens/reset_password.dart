import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/auth_state.dart';

class ResetPassword extends StatelessWidget {
  final String email;
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ResetPassword({super.key, required this.email});

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
          if (state is ResetPasswordSuccess) {
            AppSnackBar.showSuccess(context, 'Password reset successfully');
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutsName.sectionApp,
              (route) => false,
            );
          } else if (state is ResetPasswordError) {
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
                  Text(AppStrings.resetPassword,
                    style: TextStyles.bodyMedium18,
                  ),
                  Text(AppStrings.passwordMustNotBeEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyles.hintTextFieldStyle.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) => AppValidations.validatePassword(value ?? ''),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterYourPassword,
                      labelText: AppStrings.newPassword,
                    ),
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) => AppValidations.validatePassword(value ?? ''),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterYourPassword,
                      labelText: AppStrings.confirmPassword,
                    ),
                  ),
                  if (state is ResetPasswordLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (passwordController.text == confirmPasswordController.text) {
                            context.read<AuthCubit>().resetPassword(
                              email: email,
                              password: passwordController.text,
                            );
                          } else {
                            AppSnackBar.showError(context, AppStrings.passwordDoNotMatch);
                          }
                        }
                      },
                      child: Text(
                        AppStrings.confirm,
                        style: TextStyles.buttonTextStyle,
                      ),
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
