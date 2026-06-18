import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 30,
            children: [
              Text(AppStrings.forgetPassword,
                style: TextStyles.bodyMedium18,
              ),
              Text(AppStrings.pleaseEnterYourEmailAssociatedToYourAccount,
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
              ElevatedButton(onPressed: (){
                if(formKey.currentState!.validate()){
                  Navigator.pushNamed(context, '/otpScreen');
                }
              }, child: Text(AppStrings.confirm,
                style: TextStyles.buttonTextStyle,

              )),
            ],
          ),
        ),
      ),

    );
  }
}
