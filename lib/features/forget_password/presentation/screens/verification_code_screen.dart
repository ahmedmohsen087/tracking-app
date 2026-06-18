import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';

class VerificationCodeScreen extends StatelessWidget {
   VerificationCodeScreen({super.key});
  final otbController = TextEditingController();
   final formKey = GlobalKey<FormState>();

   String otp = '1111';
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
              Text(AppStrings.emailVerification,
                style: TextStyles.bodyMedium18,
              ),
              Text(AppStrings.pleaseEnterYourCodeThatSendToYourEmailAddress,
                textAlign: TextAlign.center,
                style: TextStyles.hintTextFieldStyle.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Pinput(
                length: 4,
                validator: (value) => AppValidations.validateOtp(value ?? ''),
                controller:otbController ,
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


              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.didntReceiveCode,
                    style: TextStyles.bodyRegular16,
                  ),
                  InkWell(
                    onTap: (){

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
      ),
    );
  }
}
