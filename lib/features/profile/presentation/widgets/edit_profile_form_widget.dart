import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class EditProfileFormWidget extends StatelessWidget {
  const EditProfileFormWidget({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.gender,
    required this.onGenderChanged,
    required this.onUpdate,
    this.isLoading = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String gender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onUpdate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameController,
                  validator: (v) => AppValidations.validateFirstName(v),
                  decoration: InputDecoration(labelText: AppStrings.firstName),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: lastNameController,
                  validator: (v) => AppValidations.validateLastName(v),
                  decoration: InputDecoration(labelText: AppStrings.lastName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            validator: (v) => AppValidations.validateEmail(v),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: AppStrings.emailLabel),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            validator: (v) => AppValidations.validatePhone(v),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: AppStrings.phoneNumber),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutsName.changePasswordScreen),
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                initialValue: '★★★★★★',
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutsName.changePasswordScreen,
                      ),
                      child: Text(
                        AppStrings.changePassword,
                        style: TextStyles.bodyRegular14.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.gender,
            style: TextStyles.bodyMedium18.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'female',
                    groupValue: gender.toLowerCase(),
                    activeColor: AppColors.pink,
                    onChanged: (val) {
                      if (val != null) onGenderChanged(val);
                    },
                  ),
                  Text(
                    AppStrings.female,
                    style: TextStyles.bodyRegular14,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  Radio<String>(
                    value: 'male',
                    groupValue: gender.toLowerCase(),
                    activeColor: AppColors.pink,
                    onChanged: (val) {
                      if (val != null) onGenderChanged(val);
                    },
                  ),
                  Text(
                    AppStrings.male,
                    style: TextStyles.bodyRegular14,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onUpdate,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(AppStrings.updateProfile),
            ),
          ),
        ],
      ),
    );
  }
}
