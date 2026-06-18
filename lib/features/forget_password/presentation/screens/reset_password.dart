import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';

class ResetPassword extends StatelessWidget {
   ResetPassword({super.key});
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 30,
            children: [
              Text(AppStrings.resetPassword,
                style: TextStyles.bodyMedium18,
              ),
              Text(AppStrings.passwordMustNotBeEmptyAndMustContain6CharactersWithUpperCaseLetterAndOneNumberAtLeast,
                textAlign: TextAlign.center,
                style: TextStyles.hintTextFieldStyle.copyWith(
                  color: AppColors.grey,
                ),
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) => AppValidations.validatePassword(value ?? ''),
                decoration: InputDecoration(
                  hintText: AppStrings.enterYourPassword,
                  labelText: AppStrings.newPassword,
                )),
              TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) => AppValidations.validatePassword(value ?? ''),
                decoration: InputDecoration(
                  hintText: AppStrings.enterYourPassword,
                  labelText: AppStrings.confirmPassword,
                )),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate())  {
                    if (passwordController.text == confirmPasswordController.text) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted){
                        Navigator.pop(context);
                      }
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/homeScreen');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text(AppStrings.passwordDoNotMatch),
                        ),
                      );
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
      ),
    );
  }
}
