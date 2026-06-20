import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/auth_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
   ForgetPasswordScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

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
          if (state is ForgetPasswordSuccess) {
            Navigator.pushNamed(
              context,
              AppRoutsName.otpScreen,
              arguments: emailController.text.trim(),
            );
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
                  Text(AppStrings.forgetPassword,
                    style: TextStyles.bodyMedium18,
                  ),
                  Text(AppStrings.pleaseEnterYourEmailAssociated,
                    textAlign: TextAlign.center,
                    style: TextStyles.hintTextFieldStyle.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppStrings.enterYourEmail,
                      labelText: AppStrings.email,
                    ),
                    validator:(value) => AppValidations.validateEmail(value ?? ''),
                    controller:  emailController,
                  ),
                  if (state is ForgetPasswordLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          context.read<AuthCubit>().forgetPassword(
                            emailController.text.trim(),
                          );
                        }
                      },
                      child: Text(AppStrings.confirm,
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
